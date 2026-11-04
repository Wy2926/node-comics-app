import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/modules/main_view/widgets/mobile_bottom_navigation.dart';
import 'package:mangayomi/modules/widgets/floating_nav_bar.dart';
import 'package:mangayomi/modules/widgets/nodelane_notice.dart';

void main() {
  late GoRouter router;

  setUp(() {
    router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (context, state) => const SizedBox()),
      ],
    );
  });

  tearDown(() => router.dispose());

  Widget app({required bool useFloatingNav}) {
    const destinations = ['/browse', '/more'];
    return ProviderScope(
      child: Consumer(
        builder: (context, ref, child) => MaterialApp(
          builder: BotToastInit(),
          navigatorObservers: [BotToastNavigatorObserver()],
          home: Scaffold(
            bottomNavigationBar: MainMobileBottomNavigation(
              isLongPressed: false,
              location: '/browse',
              currentIndex: 0,
              dest: destinations,
              route: router,
              ref: ref,
              useFloatingNav: useFloatingNav,
              buildNavigationWidgetsMobile: (ref, dest, context) => const [
                NavigationDestination(
                  icon: Icon(Icons.explore_outlined),
                  label: 'Browse',
                ),
                NavigationDestination(
                  icon: Icon(Icons.more_horiz),
                  label: 'More',
                ),
              ],
              onDestinationSelected: (_) {},
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('uses the standard attached bar when the preference is off', (
    tester,
  ) async {
    await tester.pumpWidget(app(useFloatingNav: false));

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(FloatingNavBar), findsNothing);
  });

  testWidgets('uses the floating bar when the preference is on', (
    tester,
  ) async {
    await tester.pumpWidget(app(useFloatingNav: true));

    expect(find.byType(FloatingNavBar), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });

  testWidgets(
    'switching retained tabs dismisses progress without reopening it on later updates',
    (tester) async {
      await tester.pumpWidget(app(useFloatingNav: false));
      final progress = showNodeLaneNotice(
        'Updating',
        kind: NodeLaneNoticeKind.progress,
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));
      expect(find.byType(NodeLaneNotice), findsOneWidget);
      await tester.tap(find.text('More'));
      await tester.pumpAndSettle();
      progress.update('Still working', progress: .5);
      await tester.pump();
      expect(find.byType(NodeLaneNotice), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
}
