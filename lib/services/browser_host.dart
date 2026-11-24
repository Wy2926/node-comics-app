import 'dart:io';

import 'package:flutter/services.dart';

const browserHost = MethodChannel('nodelane/browser');
final Future<bool> hasBrowserHost = Platform.isAndroid
    ? const OptionalMethodChannel('com.kodjodevf.mangayomi.device')
          .invokeMethod<bool>('hasGeckoBrowser')
          .then((value) => value == true)
    : Future.value(false);
