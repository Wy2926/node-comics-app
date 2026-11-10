import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../services/translation/contracts.dart';

/// The WebView owns the network session and already-loaded response bodies.
/// Extract only the current image window, then immediately discard the archive.
class WebImageArchive {
  WebImageArchive({required this.save, required this.apple});

  final Future<String?> Function(String path) save;
  final bool apple;
  Map<String, String> _sources = {};
  final _images = <String, _ArchivedImage>{};
  TranslationCancellation _life = TranslationCancellation();
  _ArchiveRead? _pending;

  void retain(Map<String, String> sources) {
    for (final key in _images.keys.toList()) {
      if (sources[key] != _sources[key]) _images.remove(key)!.release();
    }
    _sources = Map.of(sources);
  }

  Future<OriginalImageLease?> acquire(
    String key,
    TranslationCancellation cancellation,
  ) async {
    final life = _life;
    void check() {
      life.check();
      cancellation.check();
      if (!_sources.containsKey(key)) throw const TranslationCancelled();
    }

    check();
    while (!_images.containsKey(key)) {
      var read = _pending;
      if (read == null) {
        read = _ArchiveRead(Map.of(_sources), life);
        _pending = read;
        read.ready = _capture(read).whenComplete(() {
          if (identical(_pending, read)) _pending = null;
        });
      }
      await read.ready;
      check();
      // A preceding document/window may have been saving when this read began.
      if (identical(read.life, life) && read.sources[key] == _sources[key]) {
        break;
      }
    }
    final image = _images[key];
    if (image == null) return null;
    image.retain();
    return OriginalImageLease(image.file, release: image.release);
  }

  Future<void> _capture(_ArchiveRead read) async {
    Directory? directory;
    _ArchiveDirectory? owner;
    final retained = <File>{};
    try {
      read.life.check();
      directory = await (await getTemporaryDirectory()).createTemp(
        'nodelane-web-images-',
      );
      owner = _ArchiveDirectory(directory);
      final archive = File(
        p.join(directory.path, 'page.${apple ? 'webarchive' : 'mht'}'),
      );
      read.life.check();
      if (await save(archive.path) == null) return;
      read.life.check();
      final destinations = <String, File>{};
      for (final url in read.sources.values) {
        destinations.putIfAbsent(
          url,
          () => File(p.join(directory!.path, 'image-${destinations.length}')),
        );
      }
      await extractWebImages(archive, destinations, apple, read.life);
      read.life.check();
      for (final item in destinations.entries) {
        if (!await item.value.exists() || await item.value.length() == 0) {
          continue;
        }
        read.life.check();
        final image = _ArchivedImage(item.value, owner);
        for (final source in read.sources.entries) {
          if (source.value == item.key &&
              _sources[source.key] == source.value) {
            image.retain();
            _images.remove(source.key)?.release();
            _images[source.key] = image;
            retained.add(item.value);
          }
        }
      }
    } on TranslationCancelled {
      // Native archive creation cannot be interrupted. Its late file is removed.
    } on PlatformException {
      // An unavailable archive is a cache miss; the source transport still runs.
    } on MissingPluginException {
      // Non-mobile hosts can continue to use the existing HTTP source reader.
    } on FormatException {
      // Unsupported/corrupt archives do not replace the original source reader.
    } on MimeMultipartException {
      // A truncated MIME container is likewise a cache miss, not image data.
    } finally {
      if (directory != null) {
        try {
          await for (final file in directory.list()) {
            if (file is File &&
                !retained.any((kept) => p.equals(kept.path, file.path))) {
              await file.delete();
            }
          }
        } finally {
          owner!.release();
        }
      }
    }
  }

  void clear() {
    _life.cancel();
    _life = TranslationCancellation();
    retain({});
  }
}

class _ArchiveRead {
  _ArchiveRead(this.sources, this.life);
  final Map<String, String> sources;
  final TranslationCancellation life;
  late final Future<void> ready;
}

class _ArchivedImage {
  _ArchivedImage(this.file, this.directory);
  final File file;
  final _ArchiveDirectory directory;
  int _references = 0;
  void retain() {
    if (_references++ == 0) directory.retain();
  }

  void release() {
    if (--_references != 0) return;
    unawaited(() async {
      await file.delete().catchError((_) => file);
      directory.release();
    }());
  }
}

class _ArchiveDirectory {
  _ArchiveDirectory(this.directory);
  final Directory directory;
  // The capture owns a reference until it has removed the full-page archive.
  int _references = 1;
  void retain() => _references++;
  void release() {
    if (--_references == 0) {
      unawaited(directory.delete().catchError((_) => directory));
    }
  }
}

/// Chromium saves MIME multipart; WebKit saves a binary property list. Never
/// use resource URLs as file paths or forward document HTML to translation.
Future<void> extractWebImages(
  File archive,
  Map<String, File> destinations,
  bool apple,
  TranslationCancellation cancellation,
) async {
  cancellation.check();
  if (apple) {
    await const MethodChannel(
      'nodelane/web_image_archive',
    ).invokeMethod<void>('extract', {
      'archive': archive.path,
      'destinations': destinations.map((url, file) => MapEntry(url, file.path)),
    });
    cancellation.check();
    return;
  }
  final headers = <String>[];
  await for (final line
      in archive
          .openRead()
          .transform(latin1.decoder)
          .transform(const LineSplitter())) {
    cancellation.check();
    if (line.isEmpty) break;
    headers.add(line);
  }
  final type =
      RegExp(r'^content-type:\s*(.*)$', multiLine: true, caseSensitive: false)
          .firstMatch(headers.join('\n').replaceAll(RegExp(r'\n[ \t]+'), ' '))
          ?.group(1);
  final boundary = type == null
      ? null
      : ContentType.parse(type).parameters['boundary'];
  if (boundary == null) throw const FormatException('Missing archive boundary');
  // Android's native serializer ends at this marker. mime's inner part stream
  // does not close on a truncated file, so establish completion before parsing.
  final ending = '\r\n--$boundary--\r\n';
  final input = await archive.open();
  try {
    final length = await input.length();
    if (length < ending.length) throw const FormatException('Truncated archive');
    await input.setPosition(length - ending.length);
    if (latin1.decode(await input.read(ending.length)) != ending) {
      throw const FormatException('Truncated archive');
    }
  } finally {
    await input.close();
  }
  await for (final part in archive.openRead().transform(
    MimeMultipartTransformer(boundary),
  )) {
    cancellation.check();
    final location = part.headers['content-location'];
    final file = destinations[location];
    if (file == null) {
      await part.drain<void>();
      continue;
    }
    final encoding = part.headers['content-transfer-encoding']?.toLowerCase();
    Stream<List<int>> bytes = part;
    if (encoding == 'base64') {
      bytes = part
          .transform(ascii.decoder)
          .map((chunk) => chunk.replaceAll(RegExp(r'\s'), ''))
          .transform(base64.decoder);
    } else if (encoding != null && encoding != 'binary' && encoding != '8bit') {
      throw const FormatException('Unsupported image transfer encoding');
    }
    final sink = file.openWrite();
    try {
      await for (final chunk in bytes) {
        cancellation.check();
        sink.add(chunk);
        await sink.flush();
      }
    } finally {
      await sink.close();
    }
  }
}
