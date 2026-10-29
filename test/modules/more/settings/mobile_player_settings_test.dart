import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/settings/player/mobile_player_audio_screen.dart';
import 'package:mangayomi/modules/more/settings/player/mobile_player_decoder_screen.dart';
import 'package:mangayomi/modules/more/settings/player/mobile_player_screen.dart';
import 'package:mangayomi/modules/more/settings/player/player_overview_screen.dart';
import 'package:mangayomi/modules/more/settings/player/providers/player_audio_state_provider.dart';
import 'package:mangayomi/modules/more/settings/player/providers/player_decoder_state_provider.dart';
import 'package:mangayomi/modules/more/settings/player/providers/player_state_provider.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_widgets.dart';

final _writes = <(String, Object)>[];
// Models persisted values when collapsed sections release their consumers.
final _stored = <String, Object>{};
void _save(String key, Object value) {
  _stored[key] = value;
  _writes.add((key, value));
}

void main() {
  var scale = 2.5, keyboard = 0.0;

  Widget withMetrics(BuildContext context, Widget? child) => MediaQuery(
    data: MediaQuery.of(context).copyWith(
      textScaler: TextScaler.linear(scale),
      padding: const EdgeInsets.only(top: 24, bottom: 34),
      viewInsets: EdgeInsets.only(bottom: keyboard),
    ),
    child: child!,
  );

  Widget app(ProviderContainer container, Widget home) =>
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: withMetrics,
          home: home,
        ),
      );

  ProviderContainer preferences(WidgetTester tester) {
    tester.view.physicalSize = const Size(360, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final container = ProviderContainer(
      overrides: [
        defaultSubtitleLangStateProvider.overrideWith(_Subtitle.new),
        markEpisodeAsSeenTypeStateProvider.overrideWith(_Seen.new),
        defaultSkipIntroLengthStateProvider.overrideWith(_Intro.new),
        defaultDoubleTapToSkipLengthStateProvider.overrideWith(_Seek.new),
        defaultPlayBackSpeedStateProvider.overrideWith(_Speed.new),
        fullScreenPlayerStateProvider.overrideWith(_Fullscreen.new),
        forceLandscapePlayerStateProvider.overrideWith(_Landscape.new),
        useLibassStateProvider.overrideWith(_Libass.new),
        enableAniSkipStateProvider.overrideWith(_AniSkip.new),
        enableAutoSkipStateProvider.overrideWith(_AutoSkip.new),
        aniSkipTimeoutLengthStateProvider.overrideWith(_Timeout.new),
        audioPreferredLangStateProvider.overrideWith(_Languages.new),
        enableAudioPitchCorrectionStateProvider.overrideWith(_Pitch.new),
        audioChannelStateProvider.overrideWith(_Channels.new),
        volumeBoostCapStateProvider.overrideWith(_Boost.new),
        enableHardwareAccelStateProvider.overrideWith(_Hardware.new),
        hwdecModeStateProvider(rawValue: true).overrideWith(_Hwdec.new),
        useGpuNextStateProvider.overrideWith(_GpuNext.new),
        useYUV420PStateProvider.overrideWith(_Yuv.new),
        debandingStateProvider.overrideWith(_Debanding.new),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUp(() {
    scale = 2.5;
    keyboard = 0;
    _writes.clear();
    _stored.clear();
  });

  Future<void> reveal(
    WidgetTester tester,
    Finder target, {
    double delta = 250,
  }) async {
    if (target.evaluate().isEmpty) {
      await tester.scrollUntilVisible(
        target,
        delta,
        scrollable: find.byType(Scrollable).first,
      );
    }
    await Scrollable.ensureVisible(tester.element(target), alignment: 0.5);
    await tester.pumpAndSettle();
  }

  Future<void> open(
    WidgetTester tester,
    String title, {
    double delta = 250,
  }) async {
    final target = find.widgetWithText(MobileSettingsLink, title);
    await reveal(tester, target, delta: delta);
    await tester.tap(target);
    await tester.pumpAndSettle();
  }

  Future<void> choose(WidgetTester tester, String title, String label) async {
    await open(tester, title);
    final option = find.widgetWithText(ListTile, label);
    await reveal(tester, option);
    await tester.tap(option);
    await tester.pumpAndSettle();
  }

  Future<void> expand(
    WidgetTester tester,
    String title, {
    double delta = 250,
  }) async {
    final heading = find.text(title);
    await reveal(tester, heading, delta: delta);
    await tester.tap(heading);
    await tester.pumpAndSettle();
  }

  Future<void> toggle(
    WidgetTester tester,
    String title, {
    double delta = 250,
  }) async {
    final control = find.widgetWithText(MobileSettingsSwitch, title);
    await reveal(tester, control, delta: delta);
    await tester.tap(control);
    await tester.pumpAndSettle();
  }

  testWidgets(
    'player choices keep cancel, language search and separate preference writes',
    (tester) async {
      final container = preferences(tester);
      await tester.pumpWidget(app(container, const MobilePlayerScreen()));
      await tester.pumpAndSettle();
      await open(tester, 'Default playback speed');
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
      expect(_writes, isEmpty);
      await choose(tester, 'Default playback speed', 'x1.25');
      await choose(tester, 'At what point to mark the episode as seen', '90%');
      await open(tester, 'Default subtitle language');
      await tester.enterText(find.byType(TextField), 'zh');
      keyboard = 180;
      await tester.pumpWidget(app(container, const MobilePlayerScreen()));
      await tester.pumpAndSettle();
      final chinese = find.widgetWithText(ListTile, 'zh');
      await reveal(tester, chinese);
      await tester.tap(chinese);
      await tester.pumpAndSettle();
      keyboard = 0;
      await tester.pumpWidget(app(container, const MobilePlayerScreen()));
      await tester.pumpAndSettle();
      await toggle(tester, 'Enable libass');
      expect(_writes, [
        ('speed', 1.25),
        ('seen', 90),
        ('subtitle', const Locale('zh')),
        ('libass', false),
      ]);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'controls validate duration and expanding AniSkip never enables it or resets hidden values',
    (tester) async {
      final container = preferences(tester);
      await tester.pumpWidget(app(container, const MobilePlayerScreen()));
      await tester.pumpAndSettle();
      await expand(tester, 'Controls');
      expect(_writes, isEmpty);
      await open(tester, 'Intro skip duration');
      await tester.enterText(find.byType(TextField), '256');
      await tester.pumpAndSettle();
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );
      await tester.enterText(find.byType(TextField), '0');
      await tester.pumpAndSettle();
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );
      keyboard = 180;
      await tester.pumpWidget(app(container, const MobilePlayerScreen()));
      await tester.pumpAndSettle();
      final cancel = find.widgetWithText(TextButton, 'Cancel');
      await reveal(tester, cancel);
      await tester.tap(cancel);
      await tester.pumpAndSettle();
      expect(_writes, isEmpty);
      keyboard = 0;
      await tester.pumpWidget(app(container, const MobilePlayerScreen()));
      await tester.pumpAndSettle();
      await open(tester, 'Intro skip duration');
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        '85',
      );
      await tester.enterText(find.byType(TextField), '255');
      await tester.pumpAndSettle();
      final confirm = find.byType(FilledButton);
      await reveal(tester, confirm);
      await tester.tap(confirm);
      await tester.pumpAndSettle();
      await choose(tester, 'Double-tap seek duration', '3s');
      await expand(tester, 'Display');
      await toggle(tester, 'Use Fullscreen');
      await expand(tester, 'AniSkip');
      expect(_writes, [('intro', 255), ('seek', 3), ('fullscreen', true)]);
      await toggle(tester, 'Enable AniSkip');
      expect(container.read(enableAutoSkipStateProvider), isTrue);
      expect(container.read(aniSkipTimeoutLengthStateProvider), 9);
      await choose(tester, 'Button timeout', '10s');
      await toggle(tester, 'Enable AniSkip', delta: -250);
      expect(
        find.widgetWithText(MobileSettingsSwitch, 'Enable auto skip'),
        findsNothing,
      );
      await expand(tester, 'AniSkip', delta: -250);
      await expand(tester, 'AniSkip');
      expect(_writes.where((write) => write.$1 == 'aniskip'), [
        ('aniskip', true),
        ('aniskip', false),
      ]);
      await toggle(tester, 'Enable AniSkip');
      expect(container.read(enableAutoSkipStateProvider), isTrue);
      expect(container.read(aniSkipTimeoutLengthStateProvider), 10);
      expect(container.read(forceLandscapePlayerStateProvider), isFalse);
      expect(_writes.any((write) => write.$1 == 'autoSkip'), isFalse);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'audio keeps free-form and empty languages while boost only saves on release',
    (tester) async {
      final container = preferences(tester);
      await tester.pumpWidget(app(container, const MobilePlayerAudioScreen()));
      await tester.pumpAndSettle();
      await open(tester, 'Preferred languages');
      await tester.enterText(find.byType(TextField), 'cancelled');
      final cancel = find.widgetWithText(TextButton, 'Cancel');
      await reveal(tester, cancel);
      await tester.tap(cancel);
      await tester.pumpAndSettle();
      expect(_writes, isEmpty);
      await open(tester, 'Preferred languages');
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        'ja,en',
      );
      await tester.enterText(find.byType(TextField), 'jpn, eng');
      keyboard = 180;
      await tester.pumpWidget(app(container, const MobilePlayerAudioScreen()));
      await tester.pumpAndSettle();
      await reveal(tester, find.byType(FilledButton));
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();
      keyboard = 0;
      await tester.pumpWidget(app(container, const MobilePlayerAudioScreen()));
      await tester.pumpAndSettle();
      expect(_writes.single, ('languages', 'jpn, eng'));
      await open(tester, 'Preferred languages');
      await tester.enterText(find.byType(TextField), '');
      await tester.pumpAndSettle();
      await reveal(tester, find.byType(FilledButton));
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();
      expect(_writes.last, ('languages', ''));
      await choose(tester, 'Audio channels', 'Reverse stereo');
      await toggle(tester, 'Enable audio pitch correction');
      final slider = find.byType(Slider);
      await reveal(tester, slider);
      final before = _writes.length;
      final gesture = await tester.startGesture(tester.getCenter(slider));
      await gesture.moveBy(const Offset(30, 0));
      await tester.pump();
      expect(_writes, hasLength(before));
      await gesture.up();
      await tester.pumpAndSettle();
      expect(_writes, hasLength(before + 1));
      expect(_writes.last.$1, 'boost');
      expect(container.read(audioPreferredLangStateProvider), '');
      expect(
        container.read(audioChannelStateProvider),
        AudioChannel.reverseStereo,
      );
      expect(container.read(enableAudioPitchCorrectionStateProvider), isFalse);
      expect(tester.getBottomRight(slider).dy, lessThanOrEqualTo(706));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'decoder keeps raw mode while hardware is off and rendering options remain independent',
    (tester) async {
      final container = preferences(tester);
      await tester.pumpWidget(
        app(container, const MobilePlayerDecoderScreen()),
      );
      await tester.pumpAndSettle();
      await open(tester, 'Hardware Decoder');
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
      expect(_writes, isEmpty);
      await toggle(tester, 'Hardware Acceleration');
      expect(
        find.widgetWithText(MobileSettingsLink, 'Hardware Decoder'),
        findsNothing,
      );
      await toggle(tester, 'Hardware Acceleration');
      expect(
        container.read(hwdecModeStateProvider(rawValue: true)),
        'videotoolbox-copy',
      );
      await choose(tester, 'Hardware Decoder', 'mediacodec-copy');
      await choose(tester, 'Debanding', 'GPU');
      await toggle(tester, 'Use YUV420P pixel format');
      await toggle(tester, 'Enable gpu-next (Android only)');
      expect(_writes, [
        ('hardware', false),
        ('hardware', true),
        ('hwdec', 'mediacodec-copy'),
        ('debanding', DebandingType.gpu),
        ('yuv', true),
        ('gpuNext', true),
      ]);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'overview keeps every existing route and advanced expansion after returning',
    (tester) async {
      preferences(tester);
      final destinations = [
        ('Internal player', '/playerMode'),
        ('Audio', '/playerAudioScreen'),
        ('Decoder', '/playerDecoderScreen'),
        ('Custom buttons', '/customButtonScreen'),
        ('mpv config', '/playerAdvancedScreen'),
      ];
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (_, _) => const MobilePlayerOverviewScreen(),
          ),
          for (final destination in destinations)
            GoRoute(
              path: destination.$2,
              builder: (_, _) =>
                  Scaffold(appBar: AppBar(title: Text(destination.$2))),
            ),
        ],
      );
      addTearDown(router.dispose);
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: withMetrics,
        ),
      );
      await tester.pumpAndSettle();
      for (var i = 0; i < destinations.length; i++) {
        if (i == 2) await expand(tester, 'Advanced');
        await open(tester, destinations[i].$1);
        expect(find.text(destinations[i].$2), findsOneWidget);
        await tester.tap(find.byTooltip('Back'));
        await tester.pumpAndSettle();
      }
      expect(_writes, isEmpty);
      expect(tester.takeException(), isNull);
    },
  );
}

class _Subtitle extends DefaultSubtitleLangState {
  @override
  Locale build() => _stored['subtitle'] as Locale? ?? const Locale('en');
  @override
  void setLocale(Locale value) {
    state = value;
    _save('subtitle', value);
  }
}

class _Seen extends MarkEpisodeAsSeenTypeState {
  @override
  int build() => _stored['seen'] as int? ?? 75;
  @override
  void set(int value) {
    state = value;
    _save('seen', value);
  }
}

class _Intro extends DefaultSkipIntroLengthState {
  @override
  int build() => _stored['intro'] as int? ?? 85;
  @override
  void set(int value) {
    state = value;
    _save('intro', value);
  }
}

class _Seek extends DefaultDoubleTapToSkipLengthState {
  @override
  int build() => _stored['seek'] as int? ?? 10;
  @override
  void set(int value) {
    state = value;
    _save('seek', value);
  }
}

class _Speed extends DefaultPlayBackSpeedState {
  @override
  double build() => _stored['speed'] as double? ?? 1.0;
  @override
  void set(double value) {
    state = value;
    _save('speed', value);
  }
}

class _Fullscreen extends FullScreenPlayerState {
  @override
  bool build() => _stored['fullscreen'] as bool? ?? false;
  @override
  void set(bool value) {
    state = value;
    _save('fullscreen', value);
  }
}

class _Landscape extends ForceLandscapePlayerState {
  @override
  bool build() => _stored['landscape'] as bool? ?? false;
  @override
  void set(bool value) {
    state = value;
    _save('landscape', value);
  }
}

class _Libass extends UseLibassState {
  @override
  bool build() => _stored['libass'] as bool? ?? true;
  @override
  void set(bool value) {
    state = value;
    _save('libass', value);
  }
}

class _AniSkip extends EnableAniSkipState {
  @override
  bool build() => _stored['aniskip'] as bool? ?? false;
  @override
  void set(bool value) {
    state = value;
    _save('aniskip', value);
  }
}

class _AutoSkip extends EnableAutoSkipState {
  @override
  bool build() => _stored['autoSkip'] as bool? ?? true;
  @override
  void set(bool value) {
    state = value;
    _save('autoSkip', value);
  }
}

class _Timeout extends AniSkipTimeoutLengthState {
  @override
  int build() => _stored['timeout'] as int? ?? 9;
  @override
  void set(int value) {
    state = value;
    _save('timeout', value);
  }
}

class _Languages extends AudioPreferredLangState {
  @override
  String build() => _stored['languages'] as String? ?? 'ja,en';
  @override
  void set(String value) {
    state = value;
    _save('languages', value);
  }
}

class _Pitch extends EnableAudioPitchCorrectionState {
  @override
  bool build() => _stored['pitch'] as bool? ?? true;
  @override
  void set(bool value) {
    state = value;
    _save('pitch', value);
  }
}

class _Channels extends AudioChannelState {
  @override
  AudioChannel build() =>
      _stored['channels'] as AudioChannel? ?? AudioChannel.auto;
  @override
  void set(AudioChannel value) {
    state = value;
    _save('channels', value);
  }
}

class _Boost extends VolumeBoostCapState {
  @override
  int build() => _stored['boost'] as int? ?? 30;
  @override
  void set(int value) {
    state = value;
    _save('boost', value);
  }
}

class _Hardware extends EnableHardwareAccelState {
  @override
  bool build() => _stored['hardware'] as bool? ?? true;
  @override
  void set(bool value) {
    state = value;
    _save('hardware', value);
  }
}

class _Hwdec extends HwdecModeState {
  @override
  String build({bool rawValue = false}) =>
      _stored['hwdec'] as String? ?? 'videotoolbox-copy';
  @override
  void set(String value) {
    state = value;
    _save('hwdec', value);
  }
}

class _GpuNext extends UseGpuNextState {
  @override
  bool build() => _stored['gpuNext'] as bool? ?? false;
  @override
  void set(bool value) {
    state = value;
    _save('gpuNext', value);
  }
}

class _Yuv extends UseYUV420PState {
  @override
  bool build() => _stored['yuv'] as bool? ?? false;
  @override
  void set(bool value) {
    state = value;
    _save('yuv', value);
  }
}

class _Debanding extends DebandingState {
  @override
  DebandingType build() =>
      _stored['debanding'] as DebandingType? ?? DebandingType.none;
  @override
  void set(DebandingType value) {
    state = value;
    _save('debanding', value);
  }
}
