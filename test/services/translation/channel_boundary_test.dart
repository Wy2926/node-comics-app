import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/translation/translation_view_controller.dart';
import 'package:mangayomi/services/translation/contracts.dart';

/// A complete-image channel, with no official UUID, account, SSE or overlay.
class CompleteImageChannel implements TranslationChannel {
  @override
  String get id => 'fake-complete-image';
  @override
  String get label => 'Local test';
  @override
  String get scope => 'local-configuration';
  @override
  ChannelRuntime createRuntime(TranslationOptions options) =>
      _CompleteImageRuntime();
}

class _CompleteImageRuntime implements ChannelRuntime {
  final output = Completer<DisplayImageLease>();
  final updates = StreamController<void>.broadcast();
  List<TranslationTarget> window = [];
  int reads = 0;
  bool automatic = false;
  Future<void>? restoration;
  @override
  Stream<void> get changes => updates.stream;
  @override
  PageTranslationState stateFor(TranslationPage page) =>
      const PageTranslationState(
        phase: TranslationPhase.succeeded,
        result: TranslationResultRef('local-configuration', 'local-output'),
      );
  @override
  Future<void> restore(List<TranslationTarget> targets) async {
    await restoration;
  }

  @override
  void setWindow(
    String consumer,
    List<TranslationTarget> targets, {
    bool automatic = true,
  }) {
    window = targets;
    this.automatic = automatic;
  }

  @override
  void pause(String consumer) {
    window = [];
    automatic = false;
  }

  @override
  Future<void> perform(
    TranslationTarget target,
    TranslationAction action,
  ) async {}
  @override
  Future<DisplayImageLease> readResult(
    TranslationResultRef result,
    TranslationCancellation cancellation,
  ) {
    reads++;
    return output.future;
  }

  @override
  Future<void> clearResults() async {}
  @override
  Future<void> dispose() => updates.close();
}

class _UnusedSource implements SourceImageReader {
  @override
  Future<OriginalImageLease> acquire(
    TranslationPage page,
    TranslationCancellation cancellation,
  ) => throw UnimplementedError();
}

void main() {
  test('automatic scheduling requires translated display even after late cache restoration', () async {
    final runtime = _CompleteImageRuntime();
    final restored = Completer<void>();
    runtime.restoration = restored.future;
    final view = TranslationViewController()
      ..window([
        TranslationTarget(const TranslationPage('page', '1'), _UnusedSource()),
      ]);
    expect(view.enabled, isTrue);
    expect(view.showTranslation, isFalse);
    view.configure(showTranslation: true);
    view.attach(runtime); // Signing in keeps the user's translated display.
    expect(runtime.automatic, isTrue);
    view.configure(showTranslation: false);
    expect(runtime.automatic, isFalse);
    expect(view.enabled, isTrue);
    restored.complete();
    await Future<void>.delayed(Duration.zero);
    expect(
      runtime.automatic,
      isFalse,
      reason: 'Late restore cannot restart paused translation',
    );
    view.dispose();
    await runtime.dispose();
  });
  test('presentation consumes a full-image channel and rejects callbacks after account or visibility changes', () async {
    final runtime = CompleteImageChannel().createRuntime(
      const TranslationOptions(),
    ) as _CompleteImageRuntime;
    final view = TranslationViewController();
    var released = 0;
    view.attach(runtime);
    view.configure(showTranslation: true);
    view.window([
      TranslationTarget(
        const TranslationPage('source/page', 'revision'),
        _UnusedSource(),
      ),
    ]);
    expect(runtime.window, hasLength(1));
    expect(runtime.reads, 1);
    view.configure(foreground: false);
    expect(runtime.window, isEmpty);
    view.attach(null);
    runtime.output.complete(
      DisplayImageLease(
        file: File('/synthetic-local-result'),
        width: 2,
        height: 3,
        release: () => released++,
      ),
    );
    await Future<void>.delayed(Duration.zero);
    expect(view.images, isEmpty);
    expect(released, 1);
    view.dispose();
    await runtime.dispose();
  });
}
