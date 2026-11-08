import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/anime/providers/state_provider.dart';
import 'package:mangayomi/modules/anime/utils/video_prefs.dart';
import 'package:mangayomi/modules/anime/widgets/audio_section_widget.dart';
import 'package:mangayomi/modules/anime/widgets/player_settings_sections.dart';
import 'package:mangayomi/modules/anime/widgets/unified_settings_sheet.dart';
import 'package:media_kit/media_kit.dart';

void _done(BuildContext context) {
  final scope = SettingsDrilldownScope.of(context)!;
  scope.isDirectShortcut ? scope.close() : scope.goHome();
}

Widget _app({
  required List<SettingsEntry> entries,
  int initialIndex = -1,
  VoidCallback? onClosed,
}) => MaterialApp(
  theme: ThemeData(platform: TargetPlatform.iOS),
  locale: const Locale('en'),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(
    body: Builder(
      builder: (context) => Center(
        child: TextButton(
          onPressed: () async {
            await showUnifiedPlayerSettings<void>(
              context,
              title: 'Player settings',
              entries: entries,
              initialIndex: initialIndex,
            );
            onClosed?.call();
          },
          child: const Text('Open'),
        ),
      ),
    ),
  ),
);

void _size(WidgetTester tester, [Size size = const Size(360, 740)]) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

Future<void> _open(WidgetTester tester) async {
  await tester.tap(find.text('Open'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('selection returns home with its scroll and live value intact', (
    tester,
  ) async {
    _size(tester);
    final speed = ValueNotifier(1.0);
    addTearDown(speed.dispose);
    final writes = <double>[];
    var closed = 0;
    await tester.pumpWidget(
      _app(
        onClosed: () => closed++,
        entries: [
          for (var i = 0; i < 10; i++)
            SettingsEntry(
              label: 'Setting $i',
              icon: Icons.settings,
              contentBuilder: (_) => const Text('Other section'),
            ),
          SettingsEntry(
            label: 'Speed',
            icon: Icons.speed,
            valueBuilder: (_) => ValueListenableBuilder<double>(
              valueListenable: speed,
              builder: (_, value, _) => Text('$value×'),
            ),
            contentBuilder: (context) => SpeedSectionWidget(
              playbackSpeed: speed,
              onSelect: (value) {
                writes.add(value);
                speed.value = value;
              },
              onDone: () => _done(context),
            ),
          ),
        ],
      ),
    );
    await _open(tester);
    final home = find.byKey(const PageStorageKey('player-settings-home'));
    await tester.scrollUntilVisible(
      find.text('Speed'),
      200,
      scrollable: find.descendant(of: home, matching: find.byType(Scrollable)),
    );
    final scroll = tester.widget<ListView>(home).controller!;
    final offset = scroll.offset;
    expect(offset, greaterThan(0));
    await tester.tap(find.text('Speed'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('1.5x'));
    await tester.tap(find.text('1.5x'));
    await tester.pumpAndSettle();
    expect(writes, [1.5]);
    expect(closed, 0);
    expect(find.text('1.5×'), findsOneWidget);
    expect(scroll.offset, closeTo(offset, 1));

    await tester.tap(find.text('Speed'));
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(home, findsOneWidget);
    expect(writes, [1.5]);
    expect(closed, 0);
    await tester.tap(find.text('Speed'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('player-settings-close')));
    await tester.pumpAndSettle();
    expect(closed, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'shortcuts close, invalid shortcuts fall back, actions stay direct',
    (tester) async {
      _size(tester);
      final speed = ValueNotifier(1.0);
      addTearDown(speed.dispose);
      var selections = 0, actions = 0, closed = 0;
      final entries = [
        SettingsEntry(
          label: 'Speed',
          icon: Icons.speed,
          contentBuilder: (context) => SpeedSectionWidget(
            playbackSpeed: speed,
            onSelect: (_) => selections++,
            onDone: () => _done(context),
          ),
        ),
        SettingsEntry(
          label: 'Share',
          icon: Icons.share,
          onTap: (context) {
            actions++;
            final scope = SettingsDrilldownScope.of(context)!;
            scope.close();
            scope.close();
          },
        ),
      ];
      await tester.pumpWidget(
        _app(entries: entries, initialIndex: 0, onClosed: () => closed++),
      );
      await _open(tester);
      expect(find.byKey(const ValueKey('player-settings-back')), findsNothing);
      await tester.tap(find.text('1.5x'));
      await tester.pumpAndSettle();
      expect(selections, 1);
      expect(closed, 1);
      await tester.pumpWidget(
        _app(entries: entries, initialIndex: 99, onClosed: () => closed++),
      );
      await _open(tester);
      await tester.tap(find.text('Speed'));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey('player-settings-back')),
        findsOneWidget,
      );
      await tester.tap(find.byKey(const ValueKey('player-settings-back')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Share'));
      await tester.pumpAndSettle();
      expect(actions, 1);
      expect(selections, 1);
      expect(closed, 2);
      expect(find.text('Open'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'landscape keyboard keeps controls reachable and full tracks readable',
    (tester) async {
      _size(tester, const Size(640, 360));
      final controller = TextEditingController(text: '0');
      addTearDown(controller.dispose);
      final submitted = <String>[];
      var increments = 0;
      AudioTrack? selected;
      const label =
          'Original Japanese surround commentary with a complete long '
          'audio track name and the remaining edition details';
      final track = AudioTrack('7', label, 'jpn');
      await tester.pumpWidget(
        _app(
          entries: [
            SettingsEntry(
              label: 'Subtitles and audio',
              icon: Icons.subtitles,
              contentBuilder: (context) => Column(
                children: [
                  SettingsStepperRow(
                    label: 'Delay',
                    controller: controller,
                    suffix: ' ms',
                    onIncrement: () => increments++,
                    onDecrement: () {},
                    onSubmitted: submitted.add,
                  ),
                  for (var i = 0; i < 10; i++)
                    SettingsOptionRow(
                      label: 'Track $i',
                      selected: false,
                      onTap: () {},
                    ),
                  AudioSectionWidget(
                    audioOptions: [VideoPrefs(title: label, audio: track)],
                    effectiveAudioTrack: track,
                    isTrackSelected: (candidate, current) =>
                        candidate == current,
                    onSelect: (value) => selected = value,
                    onDone: () => _done(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
      await _open(tester);
      await tester.tap(find.text('Subtitles and audio'));
      await tester.pumpAndSettle();
      tester.view.viewInsets = const FakeViewPadding(bottom: 150);
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byType(TextField));
      await tester.enterText(find.byType(TextField), '-150');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(submitted, ['-150']);
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byTooltip('Increase Delay'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Increase Delay'));
      expect(increments, 1);
      final close = tester.getRect(
        find.byKey(const ValueKey('player-settings-close')),
      );
      expect(close.top, greaterThanOrEqualTo(0));
      expect(close.bottom, lessThanOrEqualTo(210));
      await tester.ensureVisible(find.text(label));
      await tester.pumpAndSettle();
      expect(tester.widget<Text>(find.text(label)).maxLines, isNull);
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();
      expect(selected, same(track));
      expect(
        find.byKey(const PageStorageKey('player-settings-home')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('subtitle field keeps focused edits across provider updates', (
    tester,
  ) async {
    _size(tester);
    final container = ProviderContainer(
      overrides: [
        subtitleSettingsStateProvider.overrideWith(_SubtitleSettings.new),
      ],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: _app(
          entries: [
            SettingsEntry(
              label: 'Appearance',
              icon: Icons.palette,
              contentBuilder: (_) => const AppearanceSectionWidget(
                useLibass: true,
                hasSubtitleTrack: true,
              ),
            ),
          ],
        ),
      ),
    );
    await _open(tester);
    await tester.tap(find.text('Appearance'));
    await tester.pumpAndSettle();
    final field = find.byType(TextField);
    await tester.ensureVisible(field);
    await tester.enterText(field, '70');
    final settings = container.read(
      subtitleSettingsStateProvider.notifier,
    ) as _SubtitleSettings;
    settings.set(PlayerSubtitleSettings(fontSize: 46), false);
    await tester.pump();
    expect(tester.widget<TextField>(field).controller!.text, '70');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    expect(settings.writes.single.fontSize, 70);
    await tester.tap(find.byKey(const ValueKey('player-settings-back')));
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsNothing);
    expect(tester.takeException(), isNull);
  });
}

class _SubtitleSettings extends SubtitleSettingsState {
  final writes = <PlayerSubtitleSettings>[];
  @override
  PlayerSubtitleSettings build() => PlayerSubtitleSettings(fontSize: 45);
  @override
  void set(PlayerSubtitleSettings value, bool end) {
    state = value;
    if (end) writes.add(value);
  }
}
