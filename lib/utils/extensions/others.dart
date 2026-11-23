import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension FileFormatter on num {
  String formattedFileSize({bool base1024 = true}) {
    if (this <= 0) return "0.00 B";
    final base = base1024 ? 1024 : 1000;
    final units = base1024
        ? ["B", "KiB", "MiB", "GiB", "TiB"]
        : ["B", "kB", "MB", "GB", "TB"];
    int digitGroups = (log(this) / log(base)).floor().clamp(
      0,
      units.length - 1,
    );
    return "${NumberFormat("#,##0.#").format(this / pow(base, digitGroups))} ${units[digitGroups]}";
  }
}

extension LetExtension<T> on T {
  R let<R>(R Function(T) block) {
    return block(this);
  }
}

extension MedianExtension on List<int> {
  int median() {
    final sorted = List<int>.from(this)..sort();
    var middle = sorted.length ~/ 2;
    if (sorted.length % 2 == 1) {
      return sorted[middle];
    } else {
      return ((sorted[middle - 1] + sorted[middle]) / 2).round();
    }
  }

  int arithmeticMean() {
    return isNotEmpty ? (reduce((e1, e2) => e1 + e2) / length).round() : 0;
  }
}

extension ImageProviderExtension on ImageProvider {
  Future<Uint8List?> getBytes(
    BuildContext context, {
    ImageByteFormat format = ImageByteFormat.png,
  }) async {
    final imageStream = resolve(createLocalImageConfiguration(context));
    final Completer<Uint8List?> completer = Completer<Uint8List?>();
    final ImageStreamListener listener = ImageStreamListener((
      imageInfo,
      synchronousCall,
    ) async {
      final bytes = await imageInfo.image.toByteData(format: format);
      if (!completer.isCompleted) {
        completer.complete(bytes?.buffer.asUint8List());
      }
    });
    imageStream.addListener(listener);
    final imageBytes = await completer.future;
    imageStream.removeListener(listener);
    return imageBytes;
  }
}

/// get md5 from key
String keyToMd5(String key) => md5.convert(utf8.encode(key)).toString();
