import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/library/providers/file_scanner.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/onboarding/onboarding_screen.dart';
import 'package:mangayomi/modules/onboarding/widgets/mobile_onboarding.dart';
import 'package:mangayomi/modules/onboarding/widgets/onboarding_folder_status.dart';

const _url = 'https://example.invalid/repository.json';
final _writes = <ItemType, List<Repo>>{};

class _Repos extends ExtensionsRepoState {
  late ItemType type;
  @override
  List<Repo> build(ItemType itemType) {
    type = itemType;
    return [];
  }

  @override
  Future<void> set(List<Repo> value) async {
    _writes[type] = value;
    state = value;
  }
}

class _Folders extends LocalFoldersState {
  @override
  List<LocalFolder> build() => [];
}

class _Hidden extends HideItemsState {
  @override
  List<String> build() => ['/trackerLibrary'];
  @override
  void set(List<String> value) => state = value;
}

class _Merged extends MergeLibraryNavMobileState {
  @override
  bool build() => false;
  @override
  void set(bool value) => state = value;
}

void main() {
  Future<void> start(
    WidgetTester tester,
    Widget child, {
    bool owner = false,
    double inset = 0,
  }) async {
    tester.view.physicalSize = owner
        ? const Size(400, 2400)
        : const Size(360, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(owner ? 1 : 2.5),
            padding: const EdgeInsets.only(top: 24, bottom: 34),
            viewInsets: EdgeInsets.only(bottom: inset),
          ),
          child: child!,
        ),
        home: child,
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> reveal(
    WidgetTester tester,
    Finder finder, {
    double delta = 180,
  }) async {
    await tester.scrollUntilVisible(
      finder,
      delta,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(finder);
    await Scrollable.ensureVisible(tester.element(finder), alignment: .5);
    await tester.pump(const Duration(milliseconds: 150));
  }

  testWidgets(
    'mobile choices keep one media and keep next and skip accessible at large text',
    (tester) async {
      var selected = {...ItemType.values};
      var busy = false, next = 0, restored = 0, skipped = 0;
      late StateSetter update;
      await start(
        tester,
        StatefulBuilder(
          builder: (context, setState) {
            update = setState;
            return MobileOnboardingFrame(
              step: 1,
              title: 'Welcome',
              description: context.l10n.onboarding_mobile_libraries_body,
              busy: busy,
              leaveLabel: 'Skip for now',
              onLeave: () => skipped++,
              onNext: () => next++,
              child: MobileOnboardingLibraries(
                selected: selected,
                busy: busy,
                onToggle: (type) => setState(() {
                  selected = {...selected}..remove(type);
                }),
                onRestore: () {
                  restored++;
                  setState(() => busy = true);
                },
              ),
            );
          },
        ),
      );
      for (final label in ['Anime', 'Novel']) {
        final tile = find.widgetWithText(NodeLaneRow, label);
        await reveal(tester, tile);
        await tester.tap(tile);
        await tester.pumpAndSettle();
      }
      final manga = find.widgetWithText(NodeLaneRow, 'Manga');
      expect(tester.widget<NodeLaneRow>(manga).enabled, isFalse);
      expect(selected, {ItemType.manga});
      final restore = find.widgetWithText(NodeLaneRow, 'Restore a backup');
      await reveal(tester, restore);
      final nextButton = find.widgetWithText(FilledButton, 'Continue');
      final skip = find.widgetWithText(TextButton, 'Skip for now');
      expect(nextButton.hitTestable(), findsOneWidget);
      expect(tester.getRect(skip).bottom, lessThanOrEqualTo(706));
      await tester.tap(restore);
      await tester.pump();
      expect(restored, 1);
      expect(tester.widget<FilledButton>(nextButton).onPressed, isNull);
      expect(tester.widget<TextButton>(skip).onPressed, isNull);
      update(() => busy = false);
      await tester.pumpAndSettle();
      await tester.tap(nextButton);
      await tester.tap(skip);
      expect((next, skipped), (1, 1));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'mobile source form keeps drafts and identity, disables busy navigation, and exposes folder details',
    (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      var type = ItemType.anime;
      var busy = false,
          backs = 0,
          skips = 0,
          folders = 0,
          removes = 0,
          browses = 0;
      String? error;
      final submissions = <(ItemType, String)>[];
      late StateSetter update;
      await start(
        tester,
        StatefulBuilder(
          builder: (context, setState) {
            update = setState;
            return MobileOnboardingFrame(
              step: 2,
              title: 'Start reading',
              description: 'You can also add content later.',
              busy: busy,
              leaveLabel: 'Skip for now',
              onLeave: () => skips++,
              onBack: () => backs++,
              child: MobileOnboardingSources(
                libraries: ItemType.values,
                repoType: type,
                onRepoType: (value) => setState(() => type = value),
                urlController: controller,
                onUrlChanged: () => setState(() => error = null),
                canAdd: controller.text.isNotEmpty,
                onAdd: () {
                  submissions.add((type, controller.text));
                  setState(() => busy = true);
                },
                busy: busy,
                repoError: error,
                onBrowse: () => browses++,
                onAddFolder: () => folders++,
                folderStatus: OnboardingFolderStatus(
                  mobile: true,
                  onAddFolder: () => folders++,
                  onRemoveFolder: () => removes++,
                  actionsEnabled: !busy,
                  message: '42 titles found',
                  path: '/sample/folder/with-a-long-name/Comics',
                  titles: List.generate(
                    42,
                    (i) => 'Sample title ${i + 1} with a long name',
                  ),
                ),
              ),
            );
          },
        ),
        inset: 260,
      );
      final browse = find.widgetWithText(NodeLaneRow, 'Browse sources');
      await reveal(tester, browse);
      await tester.tap(browse);
      expect(browses, 1);
      final repository = find.widgetWithText(
        NodeLaneRow,
        'Add a third-party repository',
      );
      await reveal(tester, repository);
      await tester.tap(repository);
      await tester.pumpAndSettle();
      final field = find.byType(TextField);
      await reveal(tester, field);
      await tester.enterText(field, '  $_url  ');
      await tester.pump();
      final add = find.widgetWithText(FilledButton, 'Add repository');
      await reveal(tester, add);
      await tester.tap(add);
      await tester.pump();
      expect(submissions, [(ItemType.anime, '  $_url  ')]);
      expect(tester.widget<TextField>(field).enabled, isFalse);
      expect(tester.widget<NodeLaneRow>(browse).enabled, isFalse);
      final back = find.byWidgetPredicate(
        (w) => w is IconButton && w.tooltip == 'Back',
      );
      expect(tester.widget<IconButton>(back).onPressed, isNull);
      final leave = find.widgetWithText(FilledButton, 'Skip for now');
      expect(tester.widget<FilledButton>(leave).onPressed, isNull);
      expect(tester.getRect(leave).bottom, lessThanOrEqualTo(480));
      update(() {
        busy = false;
        error = 'Could not read repository.';
      });
      await tester.pumpAndSettle();
      expect(controller.text, '  $_url  ');
      // Closing a disclosure unmounts the form, but the owner keeps its draft.
      await reveal(tester, repository, delta: -180);
      await tester.tap(repository);
      await tester.pumpAndSettle();
      expect(field, findsNothing);
      await tester.tap(repository);
      await tester.pumpAndSettle();
      expect(tester.widget<TextField>(field).controller!.text, '  $_url  ');
      expect(find.text('Could not read repository.'), findsOneWidget);
      await reveal(tester, find.text('View imported content'), delta: -180);
      await tester.tap(find.text('View imported content'));
      await tester.pumpAndSettle();
      expect(find.text('Sample title 40 with a long name'), findsOneWidget);
      expect(find.text('Sample title 41 with a long name'), findsNothing);
      final menu = find.byTooltip('More');
      await reveal(tester, menu, delta: -180);
      await tester.tap(menu);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Remove that folder'));
      await tester.pumpAndSettle();
      expect(removes, 1);
      expect(leave.hitTestable(), findsOneWidget);
      await tester.tap(leave);
      await tester.tap(back);
      expect((skips, backs, folders), (1, 1, 0));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'owner guards pending repository work, retains media and ignores completion after disposal',
    (tester) async {
      _writes.clear();
      var pending = Completer<Repo?>();
      var requests = 0;
      Future<void> openOwner() => start(
        tester,
        ProviderScope(
          overrides: [
            for (final type in ItemType.values)
              extensionsRepoStateProvider(type).overrideWith(_Repos.new),
            localFoldersStateProvider.overrideWith(_Folders.new),
            hideItemsStateProvider.overrideWith(_Hidden.new),
            mergeLibraryNavMobileStateProvider.overrideWith(_Merged.new),
            getRepoInfosProvider(jsonUrl: _url).overrideWith((ref) {
              requests++;
              return pending.future;
            }),
          ],
          child: const OnboardingScreen(),
        ),
        owner: true,
      );
      Future<void> toSource() async {
        await tester.tap(find.widgetWithText(FilterChip, 'Anime · 待测试'));
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(FilledButton, 'Next'));
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(FilledButton, 'Next'));
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(FilterChip, 'Anime'));
        await tester.enterText(find.byType(TextField), ' $_url ');
        await tester.pump();
        await tester.tap(find.widgetWithText(FilledButton, 'Add repository'));
        await tester.pump();
      }

      await openOwner();
      await toSource();
      expect(requests, 1);
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );
      await tester.binding.handlePopRoute();
      await tester.pump();
      expect(find.text('Add a source'), findsOneWidget);
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        ' $_url ',
      );
      pending.completeError(StateError('private repository error'));
      await tester.pumpAndSettle();
      expect(find.textContaining('private repository'), findsNothing);
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        ' $_url ',
      );
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNotNull,
      );
      pending = Completer<Repo?>();
      await tester.tap(find.widgetWithText(FilledButton, 'Add repository'));
      await tester.pump();
      final repo = Repo(name: 'Sample', jsonUrl: _url);
      pending.complete(repo);
      await tester.pumpAndSettle();
      expect(_writes.keys, [ItemType.anime]);
      expect(identical(_writes[ItemType.anime]!.single, repo), isTrue);
      await tester.pumpWidget(const SizedBox());
      pending = Completer<Repo?>();
      await openOwner();
      await toSource();
      await tester.pumpWidget(const SizedBox());
      _writes.clear();
      pending.complete(repo);
      await tester.pumpAndSettle();
      expect(_writes, isEmpty);
      expect(requests, 3);
      expect(tester.takeException(), isNull);
    },
  );
}
