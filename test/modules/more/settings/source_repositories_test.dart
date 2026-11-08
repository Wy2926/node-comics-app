import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/more/settings/browse/source_repositories.dart';
import 'package:mangayomi/services/fetch_item_sources.dart';

void main() {
  testWidgets('large-text repository dialog can be cancelled without a write', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          extensionsRepoStateProvider(ItemType.anime)
              .overrideWith(_GitHubRepoState.new),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(2)),
            child: child!,
          ),
          home: const SourceRepositories(itemType: ItemType.anime),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), 'not-a-url');
    await tester.pumpAndSettle();
    final dialog = find.byType(AlertDialog);
    final add = find.descendant(
      of: dialog,
      matching: find.widgetWithText(TextButton, 'Add'),
    );
    expect(tester.widget<TextButton>(add).onPressed, isNull);
    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pumpAndSettle();
    expect(dialog, findsNothing);
    expect(find.text('Curated extensions'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'finishing a refresh after leaving repositories does not update disposed state',
    (tester) async {
      final refresh = Completer<void>();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            extensionsRepoStateProvider(ItemType.anime)
                .overrideWith(_GitHubRepoState.new),
            fetchItemSourcesListProvider(
              id: null,
              reFresh: true,
              itemType: ItemType.anime,
            ).overrideWith((ref) => refresh.future),
          ],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (context) => Scaffold(
                body: TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) =>
                          const SourceRepositories(itemType: ItemType.anime),
                    ),
                  ),
                  child: const Text('Open repositories'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open repositories'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pump();
      await tester.tap(find.byType(BackButton));
      await tester.pump(const Duration(seconds: 1));
      refresh.complete();
      await tester.pumpAndSettle();
      expect(find.text('Open repositories'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}

class _GitHubRepoState extends ExtensionsRepoState {
  @override
  List<Repo> build(ItemType itemType) => [
    Repo(
      name: 'Curated extensions',
      jsonUrl: 'https://raw.githubusercontent.com/example/extensions/main/anime_index.json',
    ),
  ];
}
