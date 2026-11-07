import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/translation/translation_image_status.dart';
import 'package:mangayomi/modules/translation/translation_image_actions.dart';
import 'package:mangayomi/modules/translation/translation_view_controller.dart';
import 'package:mangayomi/services/translation/contracts.dart';

class _Source extends Fake implements SourceImageReader {}

class _Runtime extends Fake implements ChannelRuntime {
  final updates = StreamController<void>.broadcast();
  @override
  Future<void> restore(List<TranslationTarget> targets) async {}
  @override
  Future<void> dispose() => updates.close();
  final actions = <(String, TranslationAction)>[];
  final states = <String, PageTranslationState>{};
  Completer<void>? pendingAction;
  String? readFailure;
  @override
  Stream<void> get changes => updates.stream;
  @override
  PageTranslationState stateFor(TranslationPage page) => states[page.key]!;
  @override
  void pause(String consumer) {}
  @override
  void setWindow(
    String consumer,
    List<TranslationTarget> targets, {
    bool automatic = true,
  }) {}
  @override
  Future<void> perform(
    TranslationTarget target,
    TranslationAction action,
  ) async {
    actions.add((target.page.key, action));
    await pendingAction?.future;
  }

  @override
  Future<DisplayImageLease> readResult(
    TranslationResultRef result,
    TranslationCancellation cancellation,
  ) async {
    if (readFailure != null) throw TranslationFailure(readFailure!);
    return DisplayImageLease(
      file: File('/test-result-${result.operationId}.png'),
      width: 100,
      height: 200,
    );
  }
}

void main() {
  late TranslationViewController view;
  late _Runtime runtime;
  late TranslationTarget first, second;
  setUp(() {
    runtime = _Runtime();
    first = TranslationTarget(const TranslationPage('first', '1'), _Source());
    second = TranslationTarget(const TranslationPage('second', '1'), _Source());
    runtime.states.addAll({
      'first': const PageTranslationState(
        phase: TranslationPhase.failed,
        actions: {TranslationAction.retry},
      ),
      'second': const PageTranslationState(
        phase: TranslationPhase.uncertain,
        actions: {TranslationAction.verify},
      ),
    });
    view = TranslationViewController()
      ..attach(runtime)
      ..window([first, second])
      ..configure(showTranslation: true);
  });
  tearDown(() async {
    view.dispose();
    await runtime.dispose();
  });

  test(
    'single-image actions reject duplicates and ignore late account errors',
    () async {
      runtime.pendingAction = Completer<void>();
      final action = view.perform(first, TranslationAction.retry);
      await view.perform(first, TranslationAction.retry);
      expect(runtime.actions, [('first', TranslationAction.retry)]);
      expect(TranslationImageStatus.forTarget(view, first).action, isNull);
      expect(
        TranslationImageStatus.forTarget(view, second).action,
        TranslationAction.verify,
      );
      view.attach(null);
      runtime.pendingAction!.completeError(const TranslationFailure('NETWORK'));
      await action;
      expect(view.error, isNull);
      expect(view.state(first).phase, TranslationPhase.idle);
      expect(view.isPerforming(first), isFalse);
    },
  );

  test('result read failure offers reread without translating other images; expiry offers regeneration', () async {
    runtime.states['first'] = const PageTranslationState(
      phase: TranslationPhase.succeeded,
      result: TranslationResultRef('test', 'first'),
      actions: {TranslationAction.readResult, TranslationAction.regenerate},
    );
    runtime.readFailure = 'NETWORK';
    runtime.updates.add(null);
    await Future<void>.delayed(Duration.zero);
    expect(
      TranslationImageStatus.forTarget(view, first).action,
      TranslationAction.readResult,
    );
    expect(view.state(second).phase, TranslationPhase.uncertain);
    runtime.readFailure = null;
    await view.perform(first, TranslationAction.readResult);
    await Future<void>.delayed(Duration.zero);
    expect(view.images.keys, [first.page.identity]);
    expect(runtime.actions, [('first', TranslationAction.readResult)]);
    expect(TranslationImageStatus.forTarget(view, first).visible, isFalse);

    view.configure(foreground: false);
    runtime.readFailure = 'RESULT_EXPIRED';
    view.configure(foreground: true);
    await Future<void>.delayed(Duration.zero);
    expect(TranslationImageStatus.forTarget(view, first).action, isNull);
    expect(translationImageMenuActions(view, first), [
      TranslationAction.regenerate,
    ]);
    expect(view.state(first).message, '译图已过期，请重新翻译');
  });

  testWidgets(
    'completed and no-text images have no corner status; more regenerates only the selected image',
    (tester) async {
      runtime.states['first'] = const PageTranslationState(
        phase: TranslationPhase.succeeded,
        noText: true,
        actions: {TranslationAction.regenerate},
      );
      runtime.states['second'] = const PageTranslationState(
        phase: TranslationPhase.succeeded,
        actions: {TranslationAction.regenerate, TranslationAction.readResult},
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => Column(
                children: [
                  for (final target in [first, second])
                    TranslationImageBadge(
                      status: TranslationImageStatus.forTarget(view, target),
                    ),
                  TextButton(
                    onPressed: () =>
                        showTranslationImageMenu(context, view, first),
                    child: const Text('图片更多操作'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      expect(find.text('已翻译'), findsNothing);
      expect(find.text('无可译文字'), findsNothing);
      expect(find.text('重译'), findsNothing);
      expect(runtime.actions, isEmpty);
      await tester.tap(find.text('图片更多操作'));
      await tester.pumpAndSettle();
      expect(find.text('重新翻译此图'), findsOneWidget);
      expect(find.text('重新读取译图'), findsNothing);
      expect(runtime.actions, isEmpty);
      await tester.tap(find.text('重新翻译此图'));
      await tester.pumpAndSettle();
      expect(runtime.actions, [('first', TranslationAction.regenerate)]);
      expect(find.text('重新翻译此图'), findsNothing);
    },
  );
}
