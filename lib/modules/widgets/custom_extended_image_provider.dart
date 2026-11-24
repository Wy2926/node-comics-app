// ignore_for_file: non_nullable_equals_parameter, implementation_imports
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui show Codec, ImmutableBuffer;

import 'package:extended_image_library/src/extended_image_provider.dart';
import 'package:extended_image_library/src/platform.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:http_client_helper/http_client_helper.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/models/source_image_processing.dart';
import 'package:mangayomi/services/source_images/tile_shuffle.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/services/http/source_session_client.dart';
import 'package:mangayomi/utils/avif.dart';
import 'package:mangayomi/utils/downloaded_page_file.dart';
import 'package:path/path.dart';
import 'package:extended_image_library/src/network/extended_network_image_provider.dart'
    as image_provider;

// NOTE: encoded image bytes are intentionally NOT cached in memory here.
// The on-disk cache plus Flutter's decoded imageCache already cover repeat
// loads; an extra encoded-bytes layer only added ~50MB of resident memory.

/// Cache metadata for LRU eviction
class _CacheMetadata {
  final String path;
  final int size;
  final DateTime lastAccessed;

  _CacheMetadata({
    required this.path,
    required this.size,
    required this.lastAccessed,
  });
}

/// Global cache manager
class _CacheManager {
  static const _maxCacheSize = 500 * 1024 * 1024; // 500MB
  static final Map<String, DateTime> _lastEvictionCheck = {};
  static const _evictionThrottleInterval = Duration(minutes: 10);
  static bool _isEvicting = false;
  static final retained = <String, int>{};

  static Future<int> getCacheSize(Directory cacheDir) async {
    if (!await cacheDir.exists()) return 0;

    int totalSize = 0;
    try {
      await for (final entity in cacheDir.list()) {
        if (entity is File) {
          totalSize += await entity.length();
        }
      }
    } catch (_) {}
    return totalSize;
  }

  /// Triggers cache eviction asynchronously in the background without blocking the UI
  static void evictOldestIfNeededThrottled(Directory cacheDir) {
    final now = DateTime.now();
    final lastCheck = _lastEvictionCheck[cacheDir.path];
    if (lastCheck != null &&
        now.difference(lastCheck) < _evictionThrottleInterval) {
      return;
    }
    _lastEvictionCheck[cacheDir.path] = now;
    unawaited(evictOldestIfNeeded(cacheDir));
  }

  static Future<void> evictOldestIfNeeded(Directory cacheDir) async {
    if (_isEvicting) return;
    _isEvicting = true;
    try {
      final size = await getCacheSize(cacheDir);
      if (size <= _maxCacheSize) return;

      // Collect all cache files with metadata
      final List<_CacheMetadata> files = [];
      await for (final entity in cacheDir.list()) {
        if (entity is File) {
          try {
            final stat = await entity.stat();
            final lastTime = stat.accessed.isAfter(stat.modified)
                ? stat.accessed
                : stat.modified;
            files.add(
              _CacheMetadata(
                path: entity.path,
                size: stat.size,
                lastAccessed: lastTime,
              ),
            );
          } catch (_) {}
        }
      }

      // Sort by last accessed/modified (oldest first)
      files.sort((a, b) => a.lastAccessed.compareTo(b.lastAccessed));

      // Delete until under limit
      int currentSize = size;
      for (final file in files) {
        if (currentSize <= _maxCacheSize) break;
        try {
          final f = File(file.path);
          if (retained.containsKey(f.absolute.path)) continue;
          await f.delete();
          currentSize -= file.size;
        } catch (e) {
          if (kDebugMode) print('Failed to delete cache file: $e');
        }
      }
    } catch (e) {
      if (kDebugMode) print('Error during cache eviction: $e');
    } finally {
      _isEvicting = false;
    }
  }
}

typedef _FetchedImage = ({Uint8List bytes, File? file});

class CustomExtendedNetworkImageProvider
    extends ImageProvider<image_provider.ExtendedNetworkImageProvider>
    with ExtendedImageProvider<image_provider.ExtendedNetworkImageProvider>
    implements image_provider.ExtendedNetworkImageProvider {
  /// Deduplication map for in-flight image downloads to prevent multiple concurrent HTTP GET requests for the same URL
  static final _downloads = <(String?, String, bool), Future<_FetchedImage?>>{};

  /// Keep a reader's encoded window eligible for display even over the LRU budget.
  static VoidCallback retainFile(File file) {
    final path = file.absolute.path;
    final retained = _CacheManager.retained;
    retained[path] = (retained[path] ?? 0) + 1;
    return () {
      final remaining = retained[path]! - 1;
      if (remaining == 0) {
        retained.remove(path);
      } else {
        retained[path] = remaining;
      }
    };
  }

  /// Decode Base64 or URL-encoded data URI (e.g. data:image/gif;base64,...)
  static Uint8List? tryDecodeDataUri(String url) {
    try {
      return UriData.parse(url).contentAsBytes();
    } on FormatException {
      // Some sources wrap their base64 across lines.
      if (url.startsWith('data:') &&
          url.contains(';base64,') &&
          url.contains(RegExp(r'\s'))) {
        return tryDecodeDataUri(url.replaceAll(RegExp(r'\s+'), ''));
      }
      return null;
    }
  }

  /// Creates an object that fetches the image at the given URL.
  ///
  /// The arguments must not be null.
  CustomExtendedNetworkImageProvider(
    this.url, {
    this.scale = 1.0,
    this.headers,
    this.cache = true,
    this.retries = 3,
    this.timeLimit,
    this.timeRetry = const Duration(milliseconds: 100),
    String? cacheKey,
    this.imageProcessing,
    this.sessionOrigins = const {},
    this.printError = true,
    this.cacheRawData = false,
    this.cancelToken,
    this.imageCacheName,
    this.imageCacheFolderName,
    this.cacheMaxAge = const Duration(days: 30),
    this.showCloudFlareError = false,
  }) : cacheKey = imageProcessing?.cacheKey(cacheKey ?? url) ?? cacheKey;

  /// The name of [ImageCache], you can define custom [ImageCache] to store this provider.
  @override
  final String? imageCacheName;

  /// Whether cache raw data if you need to get raw data directly.
  /// For example, we need raw image data to edit,
  /// but [ui.Image.toByteData()] is very slow. So we cache the image
  /// data here.
  @override
  final bool cacheRawData;

  /// The time limit to request image
  @override
  final Duration? timeLimit;

  /// The time to retry to request
  @override
  final int retries;

  /// The time duration to retry to request
  @override
  final Duration timeRetry;

  /// Whether cache image to local
  @override
  final bool cache;

  /// The URL from which the image will be fetched.
  @override
  final String url;

  /// The scale to place in the [ImageInfo] object of the image.
  @override
  final double scale;

  /// The HTTP headers that will be used with [HttpClient.get] to fetch image from network.
  @override
  final Map<String, String>? headers;

  /// The token to cancel network request
  @override
  final CancellationToken? cancelToken;

  /// Custom cache key
  @override
  final String? cacheKey;

  /// print error
  @override
  final bool printError;

  /// The max duration to cache image.
  /// After this time the cache is expired and the image is reloaded.
  @override
  final Duration? cacheMaxAge;

  final bool showCloudFlareError;
  final SourceImageProcessing? imageProcessing;
  final Set<String> sessionOrigins;

  final String? imageCacheFolderName;

  @override
  ImageStreamCompleter loadImage(
    image_provider.ExtendedNetworkImageProvider key,
    ImageDecoderCallback decode,
  ) {
    // Ownership of this controller is handed off to [_loadAsync]; it is that
    // method's responsibility to close the controller's stream when the image
    // has been loaded or an error is thrown.
    final StreamController<ImageChunkEvent> chunkEvents =
        StreamController<ImageChunkEvent>();

    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(
        key as CustomExtendedNetworkImageProvider,
        chunkEvents,
        decode,
      ).whenComplete(chunkEvents.close),
      scale: key.scale,
      chunkEvents: chunkEvents.stream,
      debugLabel: 'Source image',
      informationCollector: () {
        return <DiagnosticsNode>[
          DiagnosticsProperty<ImageProvider>('Image provider', this),
          DiagnosticsProperty<image_provider.ExtendedNetworkImageProvider>(
            'Image key',
            key,
          ),
        ];
      },
    );
  }

  @override
  Future<CustomExtendedNetworkImageProvider> obtainKey(
    ImageConfiguration configuration,
  ) {
    return SynchronousFuture<CustomExtendedNetworkImageProvider>(this);
  }

  @override
  Future<bool> evict({
    ImageCache? cache,
    ImageConfiguration configuration = ImageConfiguration.empty,
    bool includeLive = true,
  }) async {
    try {
      final cacheFile = await _cacheFile;
      if (await cacheFile.exists()) {
        await cacheFile.delete();
      }
    } catch (_) {}
    return super.evict(
      cache: cache,
      configuration: configuration,
      includeLive: includeLive,
    );
  }

  @override
  Future<ui.Codec> instantiateImageCodec(
    Uint8List data,
    ImageDecoderCallback decode,
  ) async {
    try {
      return await super.instantiateImageCodec(data, decode);
    } catch (_) {
      if (!Platform.isIOS || !isAvifImage(data)) rethrow;
      final png = await decodeAvifToPng(data);
      return decode(await ui.ImmutableBuffer.fromUint8List(png));
    }
  }

  Future<ui.Codec> _loadAsync(
    CustomExtendedNetworkImageProvider key,
    StreamController<ImageChunkEvent> chunkEvents,
    ImageDecoderCallback decode,
  ) async {
    assert(key == this);
    final file = await cachedFile;
    if (file != null) {
      try {
        return await instantiateImageCodec(await file.readAsBytes(), decode);
      } catch (_) {
        await file.delete().catchError((_) => file);
      }
    }
    final image = await _fetch(chunkEvents);
    if (image == null) throw StateError('Could not load source image');
    return instantiateImageCodec(image.bytes, decode);
  }

  String get _diskKey => cacheKey ?? keyToMd5(url);
  Future<File> get _cacheFile async => File(
    join(
      (await StorageProvider().getCacheDirectory(imageCacheFolderName)).path,
      _diskKey,
    ),
  );

  Future<File?> get cachedFile async {
    if (!cache) return null;
    try {
      final file = await _cacheFile;
      final stat = await file.stat();
      if (stat.type != FileSystemEntityType.file) return null;
      final now = DateTime.now();
      if (stat.size > 0 &&
          (cacheMaxAge == null ||
              now.difference(stat.modified) <= cacheMaxAge!)) {
        unawaited(file.setLastModified(now).catchError((_) {}));
        return file;
      }
      await file.delete();
    } catch (_) {
      // The source remains usable if the optional cache is unavailable.
    }
    return null;
  }

  Future<_FetchedImage?> _fetch(
    StreamController<ImageChunkEvent>? chunkEvents,
  ) async {
    final requestKey = (imageCacheFolderName, _diskKey, cache);
    final existingRequest = _downloads[requestKey];
    if (existingRequest != null) {
      return await existingRequest;
    }

    final future = _loadNetwork(chunkEvents)
        .then<_FetchedImage?>((bytes) async {
          if (bytes == null || bytes.isEmpty) return null;
          File? file;
          if (cache) {
            try {
              final directory = await StorageProvider().createCacheDirectory(
                imageCacheFolderName,
              );
              file = await cacheImageBytesToTempFile(
                tempDir: directory,
                baseName: _diskKey,
                extension: '',
                bytesProvider: () => bytes,
              );
              _CacheManager.evictOldestIfNeededThrottled(directory);
            } catch (_) {
              // Still display the downloaded bytes when the optional disk cache is unavailable.
            }
          }
          return (bytes: bytes, file: file);
        });
    _downloads[requestKey] = future;
    try {
      return await future;
    } finally {
      _downloads.remove(requestKey);
    }
  }

  /// Get the image from network.
  Future<Uint8List?> _loadNetwork(
    StreamController<ImageChunkEvent>? chunkEvents,
  ) async {
    try {
      if (url.startsWith('data:')) {
        final bytes = tryDecodeDataUri(url);
        if (bytes == null) throw const FormatException('Invalid inline image');
        return imageProcessing == null
            ? bytes
            : await _restore(bytes, const {});
      }
      final Uri resolved = Uri.base.resolve(url);
      final StreamedResponse? response = await _tryGetResponse(resolved);

      if (response == null || response.statusCode != HttpStatus.ok) {
        await response?.stream.listen((_) {}).cancel();
        return null;
      }

      if (imageProcessing != null) {
        return await _restore(
          await readBoundedSourceImage(response),
          response.headers,
        );
      }
      final int total = response.contentLength ?? 0;
      final BytesBuilder bytesBuilder = BytesBuilder(copy: false);
      int received = 0;

      await for (final chunk in response.stream) {
        bytesBuilder.add(chunk);
        received += chunk.length;
        chunkEvents?.add(
          ImageChunkEvent(
            cumulativeBytesLoaded: received,
            expectedTotalBytes: total > 0 ? total : null,
          ),
        );
      }

      final Uint8List bytes = bytesBuilder.takeBytes();
      if (bytes.isEmpty) {
        throw StateError('Empty source image');
      }

      return bytes;
    } on OperationCanceledError {
      rethrow;
    } on FormatException {
      rethrow;
    } catch (_) {
      if (imageProcessing != null) rethrow;
    }
    return null;
  }

  Future<Uint8List> _restore(
    Uint8List bytes,
    Map<String, String> headers,
  ) async {
    try {
      return await restoreSourceImageInBackground(
        bytes,
        headers,
        imageProcessing!,
        checkCancelled: () => cancelToken?.throwIfCancellationRequested(),
      );
    } on StateError {
      throw const FormatException(
        'Invalid source image or restoration metadata',
      );
    }
  }

  Future<StreamedResponse> _getResponse(Uri resolved) async {
    // Optimize headers for better caching and compression
    final optimizedHeaders = {
      'Accept-Encoding': 'gzip, deflate, br',
      'Accept': 'image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8',
      'Connection': 'keep-alive',
      ...?headers,
    };

    var request = Request('GET', resolved);
    request.headers.addAll(optimizedHeaders);
    if (request.headers['User-Agent'] == 'Aidoku') {
      request.headers['User-Agent'] = settingsRepository.current.userAgent!;
    }
    final client = MClient.init(showCloudFlareError: showCloudFlareError);
    if (sourceSessionMatches(sessionOrigins, resolved, request.headers)) {
      return SourceSessionClient(sessionOrigins, client).send(request);
    }
    StreamedResponse response = await client.send(request);

    if (response.statusCode != HttpStatus.ok) {
      await response.stream.listen((_) {}).cancel();
      final retryRequest = Request('GET', resolved);
      retryRequest.headers.addAll(request.headers);
      final res = await MClient.init(
        reqcopyWith: {'useDartHttpClient': true},
        showCloudFlareError: showCloudFlareError,
      ).send(retryRequest);
      return res;
    }

    return response;
  }

  // Http get with cancel, exponential backoff retry
  Future<StreamedResponse?> _tryGetResponse(Uri resolved) async {
    cancelToken?.throwIfCancellationRequested();

    int attempt = 0;
    while (attempt < retries) {
      try {
        return await CancellationTokenSource.register(
          cancelToken,
          _getResponse(resolved),
        );
      } catch (e) {
        attempt++;
        if (attempt >= retries) {
          rethrow;
        }

        // Exponential backoff: 100ms, 200ms, 400ms, 800ms, etc.
        final backoffDelay = Duration(
          milliseconds: timeRetry.inMilliseconds * (1 << attempt),
        );

        if (kDebugMode) {
          print(
            'Retry attempt $attempt/$retries after ${backoffDelay.inMilliseconds}ms',
          );
        }

        await Future.delayed(backoffDelay);
        cancelToken?.throwIfCancellationRequested();
      }
    }

    return null;
  }

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is CustomExtendedNetworkImageProvider &&
        url == other.url &&
        scale == other.scale &&
        cacheRawData == other.cacheRawData &&
        timeLimit == other.timeLimit &&
        cancelToken == other.cancelToken &&
        timeRetry == other.timeRetry &&
        cache == other.cache &&
        cacheKey == other.cacheKey &&
        //headers == other.headers &&
        retries == other.retries &&
        imageCacheName == other.imageCacheName &&
        cacheMaxAge == other.cacheMaxAge;
  }

  @override
  int get hashCode => Object.hash(
    url,
    scale,
    cacheRawData,
    timeLimit,
    cancelToken,
    timeRetry,
    cache,
    cacheKey,
    //headers,
    retries,
    imageCacheName,
    cacheMaxAge,
  );

  @override
  String toString() => '$runtimeType(scale: $scale)';

  @override
  /// Get network image data from cached
  Future<Uint8List?> getNetworkImageData({
    StreamController<ImageChunkEvent>? chunkEvents,
  }) async {
    final file = await cachedFile;
    if (file != null) {
      try {
        return await file.readAsBytes();
      } on FileSystemException {
        // Eviction between lookup and open is a cache miss.
      }
    }
    return (await _fetch(chunkEvents))?.bytes;
  }

  Future<File?> loadFile({StreamController<ImageChunkEvent>? progress}) async {
    final file = await cachedFile;
    if (file != null) return file;
    final image = await _fetch(progress);
    if (image == null) return null;
    return image.file ??
        (throw const FileSystemException('Cannot store the page image'));
  }

  @override
  WebHtmlElementStrategy get webHtmlElementStrategy =>
      WebHtmlElementStrategy.fallback;
}
