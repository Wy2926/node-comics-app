import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Prime Flutter's image cache instead of injecting a decoded bitmap into the model.
Future<Uint8List> cachedReaderPng(
  WidgetTester tester,
  int width,
  int height,
) async {
  return (await tester.runAsync(() async {
    final recorder = ui.PictureRecorder();
    Canvas(recorder).drawColor(Colors.blue, BlendMode.src);
    final picture = recorder.endRecording();
    final image = await picture.toImage(width, height);
    picture.dispose();
    final bytes = (await image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
    image.dispose();
    final provider = MemoryImage(bytes);
    final stream = provider.resolve(ImageConfiguration.empty);
    final ready = Completer<void>();
    final listener = ImageStreamListener((info, _) {
      info.dispose();
      ready.complete();
    });
    stream.addListener(listener);
    await ready.future;
    stream.removeListener(listener);
    addTearDown(provider.evict);
    return bytes;
  }))!;
}
