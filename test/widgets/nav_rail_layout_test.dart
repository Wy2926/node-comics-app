import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/platform_utils.dart';

void main() {
  test('a phone in landscape is still a phone', () {
    // Judged on the shortest side. By width alone a rotated phone is over 600
    // and was handed a rail the moment it turned.
    expect(sizeWantsNavRail(const Size(390, 844)), isFalse, reason: 'portrait');
    expect(
      sizeWantsNavRail(const Size(844, 390)),
      isFalse,
      reason: 'the same phone, rotated',
    );
    expect(sizeWantsNavRail(const Size(1024, 768)), isTrue, reason: 'tablet');
    expect(sizeWantsNavRail(const Size(768, 1024)), isTrue);
  });

  test('floating navigation stays opt-in and follows TV detection', () {
    addTearDown(() => debugIsTvOverride = null);
    final supported = {
      'android',
      'ios',
      'macos',
      'linux',
    }.contains(Platform.operatingSystem);
    for (final tv in [false, true, false]) {
      debugIsTvOverride = tv;
      expect(shouldUseFloatingNav(enabled: false), isFalse);
      expect(shouldUseFloatingNav(enabled: true), supported && !tv);
    }
    expect(sizeWantsNavRail(const Size(1920, 1080)), isTrue);
  });

  testWidgets('a tablet keeps its rail until floating navigation is enabled', (
    tester,
  ) async {
    late bool withStandardNavigation;
    late bool withFloatingNavigation;

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(size: Size(1024, 768)),
        child: MaterialApp(
          home: Builder(
            builder: (context) {
              withStandardNavigation = context.prefersNavRail(
                useFloatingNav: false,
              );
              withFloatingNavigation = context.prefersNavRail(
                useFloatingNav: true,
              );
              return const SizedBox();
            },
          ),
        ),
      ),
    );

    expect(withStandardNavigation, isTrue);
    expect(withFloatingNavigation, isFalse);
  });
}
