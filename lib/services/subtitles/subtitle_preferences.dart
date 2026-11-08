import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/services/nodelane_private_storage.dart';

import 'imdb_catalog.dart';
import 'subtitle_http.dart';
import 'subtitle_service.dart';
import 'wyzie_subtitle_source.dart';

enum SubtitleConnectionMode { disabled, personalKey, customService }

class SubtitlePreferences {
  const SubtitlePreferences.disabled()
    : mode = SubtitleConnectionMode.disabled,
      endpoint = null,
      credential = '';

  SubtitlePreferences.personalKey(String key)
    : mode = SubtitleConnectionMode.personalKey,
      endpoint = null,
      credential = key.trim() {
    if (credential.isEmpty || RegExp(r'\s').hasMatch(credential)) {
      throw const SubtitleFailure(SubtitleFailureCode.configuration);
    }
  }

  SubtitlePreferences.customService(String address, {String token = ''})
    : mode = SubtitleConnectionMode.customService,
      endpoint = Uri.tryParse(address.trim()),
      credential = token.trim() {
    if (endpoint == null ||
        !validEndpoint(endpoint!) ||
        RegExp(r'\s').hasMatch(credential)) {
      throw const SubtitleFailure(SubtitleFailureCode.configuration);
    }
  }

  final SubtitleConnectionMode mode;
  final Uri? endpoint;
  final String credential;

  static bool validEndpoint(Uri uri) =>
      isSubtitleHttpsUrl(uri) && !uri.hasQuery;
}

/// Private, device-local storage, outside Settings and exported app backups.
class SubtitlePreferencesStore {
  static const storageKey = 'nodelane.subtitles.connection.v1';

  Future<SubtitlePreferences> read() async {
    final raw = await nodeLanePrivateVault.read(key: storageKey);
    if (raw == null) return const SubtitlePreferences.disabled();
    try {
      final value = jsonDecode(raw) as Map<String, dynamic>;
      return switch (value['mode']) {
        'personalKey' => SubtitlePreferences.personalKey(
          value['credential'] as String,
        ),
        'customService' => SubtitlePreferences.customService(
          value['endpoint'] as String,
          token: value['credential'] as String,
        ),
        _ => throw const SubtitleFailure(SubtitleFailureCode.configuration),
      };
    } catch (_) {
      throw const SubtitleFailure(SubtitleFailureCode.configuration);
    }
  }

  Future<void> write(SubtitlePreferences value) async {
    if (value.mode == SubtitleConnectionMode.disabled) {
      await nodeLanePrivateVault.delete(key: storageKey);
    } else {
      await nodeLanePrivateVault.write(
        key: storageKey,
        value: jsonEncode({
          'mode': value.mode.name,
          if (value.endpoint != null) 'endpoint': value.endpoint.toString(),
          'credential': value.credential,
        }),
      );
    }
  }
}

final subtitlePreferencesStoreProvider = Provider(
  (ref) => SubtitlePreferencesStore(),
);

final subtitlePreferencesProvider =
    AsyncNotifierProvider<SubtitlePreferencesController, SubtitlePreferences>(
      SubtitlePreferencesController.new,
      retry: (_, _) => null,
    );

class SubtitlePreferencesController extends AsyncNotifier<SubtitlePreferences> {
  @override
  Future<SubtitlePreferences> build() =>
      ref.watch(subtitlePreferencesStoreProvider).read();

  Future<void> save(SubtitlePreferences value) async {
    await ref.read(subtitlePreferencesStoreProvider).write(value);
    if (ref.mounted) state = AsyncData(value);
  }
}

/// The composition boundary for subtitle access. A future NodeLane source
/// resolves the signed-in user's cloud credential here, scoped to that account;
/// neither the player nor the local preferences need an app-wide key.
final subtitleSearchServiceProvider = FutureProvider.autoDispose
    .family<SubtitleSearchService?, Object>((ref, _) async {
      final preferences = await ref.watch(subtitlePreferencesProvider.future);
      if (!ref.mounted || preferences.mode == SubtitleConnectionMode.disabled) {
        return null;
      }
      final http = SubtitleHttp();
      ref.onDispose(http.close);
      final source = switch (preferences.mode) {
        SubtitleConnectionMode.personalKey => WyzieSubtitleSource.personal(
          http,
          preferences.credential,
        ),
        SubtitleConnectionMode.customService => WyzieSubtitleSource.custom(
          http,
          preferences.endpoint!,
          token: preferences.credential,
        ),
        SubtitleConnectionMode.disabled => throw StateError(
          'Disabled subtitles',
        ),
      };
      return SubtitleSearchService(
        catalog: ImdbSubtitleCatalog(http),
        source: source,
      );
    }, retry: (_, _) => null);
