import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:url_launcher_platform_interface/link.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

const publicPricingUrl = 'https://comics.nodelane.net/pricing/';

class PricingLauncher extends UrlLauncherPlatform {
  static PricingLauncher install() {
    final previous = UrlLauncherPlatform.instance;
    final launcher = PricingLauncher();
    UrlLauncherPlatform.instance = launcher;
    addTearDown(() => UrlLauncherPlatform.instance = previous);
    return launcher;
  }

  final urls = <String>[];
  Completer<bool>? pending;

  @override
  LinkDelegate? get linkDelegate => null;

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) {
    expect(options.mode, PreferredLaunchMode.externalApplication);
    urls.add(url);
    return pending?.future ?? Future.value(true);
  }
}
