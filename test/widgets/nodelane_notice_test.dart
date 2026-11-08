import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/widgets/nodelane_notice.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

void main() {
  Future<void> mount(
    WidgetTester tester, {
    Widget? body,
    double bar = 0,
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(platform: TargetPlatform.iOS),
        builder: BotToastInit(),
        navigatorObservers: [BotToastNavigatorObserver()],
        home: Scaffold(
          body: body ?? const SizedBox.expand(),
          bottomNavigationBar: NodeLaneNoticeAvoidance(
            child: SizedBox(height: bar, child: const Text('navigation')),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  Future<void> appear(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));
    await tester.pump();
  }

  testWidgets(
    'one notice above navigation; outside taps still work; keyboard wins',
    (tester) async {
      var taps = 0;
      await mount(
        tester,
        bar: 80,
        body: Center(
          child: TextButton(
            onPressed: () => taps++,
            child: const Text('page action'),
          ),
        ),
      );
      showNodeLaneNotice('Copied', kind: NodeLaneNoticeKind.success);
      await appear(tester);
      expect(
        tester.getBottomLeft(find.byType(NodeLaneNotice)).dy,
        closeTo(844 - 80 - 12, 1),
      );
      await tester.tap(find.text('page action'));
      expect(taps, 1);
      tester.view.viewInsets = const FakeViewPadding(bottom: 300);
      await appear(tester);
      expect(
        tester.getBottomLeft(find.byType(NodeLaneNotice)).dy,
        lessThanOrEqualTo(844 - 300 - 12),
      );
      showNodeLaneNotice('Replacement');
      await appear(tester);
      expect(find.text('Copied'), findsNothing);
      expect(find.text('Replacement'), findsOneWidget);
      await tester.pump(const Duration(seconds: 4));
      await tester.pump(const Duration(milliseconds: 250));
      expect(find.byType(NodeLaneNotice), findsNothing);
      showNodeLaneNotice('Swipe away');
      await appear(tester);
      await tester.fling(
        find.byType(NodeLaneNotice),
        const Offset(400, 0),
        1000,
      );
      await tester.pumpAndSettle();
      expect(find.text('Swipe away'), findsNothing);
    },
  );

  testWidgets(
    'progress updates in place and late completion cannot close another notice',
    (tester) async {
      await mount(tester);
      final first = showNodeLaneNotice(
        'Updating',
        kind: NodeLaneNoticeKind.progress,
        progress: 0,
      );
      await appear(tester);
      first.update('Updating', description: '12 / 36', progress: 1 / 3);
      await tester.pump();
      expect(find.byType(NodeLaneNotice), findsOneWidget);
      expect(
        tester
            .widget<LinearProgressIndicator>(
              find.byType(LinearProgressIndicator),
            )
            .value,
        closeTo(1 / 3, .001),
      );
      showNodeLaneNotice('Other task finished');
      await appear(tester);
      first.dismiss();
      first.update('Stale');
      await tester.pump();
      expect(find.text('Other task finished'), findsOneWidget);
      expect(find.text('Stale'), findsNothing);
    },
  );

  testWidgets('action executes once and reports async failure without replay', (
    tester,
  ) async {
    await mount(tester);
    final completer = Completer<void>();
    var actions = 0;
    showNodeLaneNotice(
      'Backup created',
      description: 'Save the file.',
      actionLabel: 'Share',
      onAction: () {
        actions++;
        return completer.future;
      },
    );
    await appear(tester);
    await tester.tap(find.text('Share'));
    await tester.tap(find.text('Share'));
    expect(actions, 1);
    completer.completeError(StateError('private-path'));
    await appear(tester);
    expect(find.textContaining('Check its result'), findsOneWidget);
    expect(find.textContaining('private-path'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'closing progress dismisses presentation only; navigation clears stale actions',
    (tester) async {
      late BuildContext pageContext;
      await mount(
        tester,
        body: Builder(
          builder: (context) {
            pageContext = context;
            return const SizedBox.expand();
          },
        ),
      );
      final handle = showNodeLaneNotice(
        'Progress',
        kind: NodeLaneNoticeKind.progress,
      );
      await appear(tester);
      await tester.tap(find.byTooltip('Close'));
      await appear(tester);
      handle.update('Still running');
      await tester.pump();
      expect(find.byType(NodeLaneNotice), findsNothing);
      showNodeLaneNotice('Old route', actionLabel: 'Open', onAction: () {});
      await appear(tester);
      Navigator.of(pageContext).push(
        MaterialPageRoute<void>(
          builder: (_) => const Scaffold(body: Text('Next route')),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Old route'), findsNothing);
      expect(find.text('Next route'), findsOneWidget);
    },
  );

  testWidgets(
    'long action content stays readable in narrow RTL and inline dark mode',
    (tester) async {
      await mount(tester);
      tester.view.physicalSize = const Size(320, 568);
      var actions = 0;
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => BotToastInit()(
            context,
            MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(1.6),
                highContrast: true,
              ),
              child: child!,
            ),
          ),
          navigatorObservers: [BotToastNavigatorObserver()],
          theme: ThemeData(
            brightness: Brightness.dark,
            platform: TargetPlatform.iOS,
          ),
          home: Scaffold(
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: NodeLaneNotice(
                    message: 'Website verification required',
                    description: 'Complete verification to continue browsing this website.',
                    kind: NodeLaneNoticeKind.verification,
                    actionLabel: 'Verify website',
                    onAction: () => actions++,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      final action = find.text('Verify website');
      expect(
        tester.getTopLeft(action).dy,
        greaterThan(
          tester.getBottomLeft(find.textContaining('Complete verification')).dy,
        ),
      );
      expect(
        tester.getSize(find.byType(TextButton)).height,
        greaterThanOrEqualTo(NodeLaneTokens.minTapTarget),
      );
      await tester.tap(action);
      expect(actions, 1);
      expect(tester.takeException(), isNull);
    },
  );
}
