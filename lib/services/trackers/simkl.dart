import 'dart:convert';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:mangayomi/utils/url_protocol/protocol.dart' show appUrlScheme;
import 'package:crypto/crypto.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/models/track_search.dart';
import 'package:mangayomi/modules/more/settings/track/myanimelist/model.dart';
import 'package:mangayomi/modules/more/settings/track/providers/track_providers.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/repositories/track_repository.dart';
import 'package:mangayomi/utils/nodelane_brand.dart';

import 'base_tracker.dart';
import 'tracker_account.dart';
import 'oauth_browser.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'simkl.g.dart';

/// Anime has its own library; the existing movie/TV branch stays separate.
String _mediaType(bool isManga) => isManga ? "movies" : "anime";

/// The same choice where Simkl uses the singular: a search path and a public
/// URL.
String _searchType(bool isManga) => isManga ? "tv" : "anime";

@riverpod
class Simkl extends _$Simkl implements BaseTracker {
  Simkl({Client? client, TrackRepository? repository})
    : http =
          client ??
          MClient.init(
            reqcopyWith: {'useDartHttpClient': true},
            showCloudFlareError: false,
          ),
      _repository = repository ?? trackRepository;

  final Client http;
  final TrackRepository _repository;
  final _browser = TrackerOAuthBrowser();
  Future<bool>? _loginFuture;
  static const _issuer = 'https://simkl.com';
  static const _baseApiUrl = 'https://api.simkl.com';
  static const _redirectUri = '$appUrlScheme://simkl-auth';
  static const _clientId =
      'c2c74e7a95db1444f40967d2a7757cf3a7aeac83ae581f40de7410a219a03b63';
  static const _scope = 'media:read media:write';

  // Family instances share a grant. Simkl invalidates its previous access
  // token immediately on refresh, so only one request may refresh that grant.
  static final _refreshes = <(TrackRepository, int, String), Future<OAuth>>{};

  @override
  void build({
    required int syncId,
    required ItemType? itemType,
    required dynamic widgetRef,
  }) {
    ref.onDispose(_browser.dispose);
  }

  Future<bool> login() =>
      _loginFuture ??= _login().whenComplete(() => _loginFuture = null);

  Future<bool> _login() async {
    final keepAlive = ref.keepAlive();
    final previous = _repository.getPreferenceById(syncId)?.oAuth;
    try {
      final verifier = _randomToken();
      final state = _randomToken();
      final authorization = Uri.parse('$_issuer/oauth2/authorize').replace(
        queryParameters: {
          'client_id': _clientId,
          'redirect_uri': _redirectUri,
          'response_type': 'code',
          'scope': _scope,
          'state': state,
          'code_challenge': base64Url
              .encode(sha256.convert(ascii.encode(verifier)).bytes)
              .replaceAll('=', ''),
          'code_challenge_method': 'S256',
        },
      );
      final started = DateTime.now();
      final returned = await _browser.authenticate(
        authorization,
        callbackHost: 'simkl-auth',
      );
      if (!_unchanged(previous) ||
          DateTime.now().difference(started) > const Duration(minutes: 10) ||
          returned.scheme != appUrlScheme ||
          returned.authority != 'simkl-auth' ||
          returned.path.isNotEmpty ||
          returned.hasFragment) {
        return false;
      }
      final params = returned.queryParametersAll;
      final codes = params['code'];
      if (params.containsKey('error') ||
          codes == null ||
          codes.length != 1 ||
          codes.single.isEmpty ||
          params['state']?.length != 1 ||
          params['state']!.single != state ||
          params['iss']?.length != 1 ||
          params['iss']!.single != _issuer) {
        return false;
      }
      final oAuth = await _token({
        'grant_type': 'authorization_code',
        'code': codes.single,
        'code_verifier': verifier,
        'redirect_uri': _redirectUri,
      }, previous);
      if (!_unchanged(previous)) return false;
      final response = await _send(
        Uri.parse('$_baseApiUrl/users/settings'),
        oAuth.accessToken!,
        check: () {
          if (!_unchanged(previous)) throw StateError('Simkl account changed');
        },
      );
      _requireSuccess(response);
      if (!_unchanged(previous)) return false;
      final settings = jsonDecode(response.body) as Map<String, dynamic>;
      final id = (settings['account'] as Map?)?['id'];
      if (id is! int || id <= 0) return false;
      final user = simklAccount(settings);
      return await _replace(
        previous,
        TrackPreference(
          syncId: syncId,
          username: user.id,
          displayName: user.name,
          avatarUrl: user.avatarUrl,
          prefs: '',
          oAuth: jsonEncode(oAuth.toJson()),
          refreshing: false,
        ),
      );
    } catch (_) {
      return false;
    } finally {
      keepAlive.close();
    }
  }

  String _randomToken() {
    final random = Random.secure();
    return base64Url
        .encode(List<int>.generate(32, (_) => random.nextInt(256)))
        .replaceAll('=', '');
  }

  Future<T> _withSession<T>(Future<T> Function(OAuth) action) async {
    final keepAlive = ref.keepAlive();
    try {
      return await action(await _getOAuthForRequest());
    } finally {
      keepAlive.close();
    }
  }

  @override
  Future<List<TrackSearch>> fetchGeneralData({
    bool isManga = true,
    String rankingType = "trending",
  }) => _withSession((oAuth) async {
    /// isManga <> isMovie
    final type = _mediaType(isManga);
    final url = Uri.parse('$_baseApiUrl/$type/$rankingType').replace(
      queryParameters: {
        'extended': 'overview',
        if (rankingType == "airing") 'date': 'today',
        if (rankingType == "airing") 'sort': 'rank',
        if (rankingType == "best") 'filter': 'all',
        if (rankingType == "best") 'type': 'series',
        'limit': '15',
      },
    );
    final result = await _makeGetRequest(url, oAuth);
    final data = jsonDecode(result.body) as List?;
    return data?.map((e) {
          return TrackSearch(
            mediaId: e['ids']?['simkl_id'] ?? e['ids']?['simkl'],
            summary: e['overview'] ?? 'No summary available.',
            totalChapter: 0,
            coverUrl: e['fanart'] != null
                ? 'https://wsrv.nl/?url=https://simkl.in/fanart/${e['fanart']}_medium.jpg'
                : e['poster'] != null
                ? 'https://wsrv.nl/?url=https://simkl.in/posters/${e['poster']}_m.webp'
                : '',
            title: e['title'] ?? 'Unknown Title',
            score: (e["ratings"]?["simkl"]?["rating"] as num?)?.toDouble(),
            startDate: e["release_date"] ?? "",
            publishingType: isManga ? "movie" : "tv",
            publishingStatus: e["status"],
            trackingUrl:
                "https://simkl.com/$type/${e['ids']?['simkl_id'] ?? e['ids']?['simkl']}",
            syncId: syncId,
          );
        }).toList() ??
        [];
  });

  @override
  Future<List<TrackSearch>> fetchUserData({
    bool isManga = true,
  }) => _withSession((oAuth) async {
    final type = _mediaType(isManga);
    final url = Uri.parse('$_baseApiUrl/sync/all-items/$type');
    final result = await _makeGetRequest(url, oAuth);
    final data = jsonDecode(result.body) as Map<String, dynamic>?;
    return (data?[type] as List?)?.map((e) {
          // Simkl models anime as shows internally, so an entry under the
          // anime key can still arrive with a "show" node. Accept either
          // rather than depend on which one this account happens to get.
          final node = e['anime'] ?? e['show'] ?? e['movie'];
          return TrackSearch(
            mediaId: node['ids']?['simkl'],
            summary: 'No summary available.',
            totalChapter: isManga ? 1 : e['total_episodes_count'],
            coverUrl: node['poster'] != null
                ? "https://wsrv.nl/?url=https://simkl.in/posters/${node['poster']}_m.jpg"
                : "",
            title: node['title'] ?? 'Unknown Title',
            score: 0,
            startDate: "",
            publishingType: isManga ? "movie" : "anime",
            publishingStatus: e["status"],
            trackingUrl: "https://simkl.com/$type/${node['ids']?['simkl']}",
            syncId: syncId,
          );
        }).toList() ??
        [];
  });

  @override
  Future<Track?> findLibItem(Track track, bool isManga) => _withSession((
    oAuth,
  ) async {
    final url = Uri.parse('$_baseApiUrl/sync/watched/')
        .replace(queryParameters: {"extended": "episodes,specials,counters"});
    final result = await _makePostRequest(url, oAuth, [
      {"simkl": track.mediaId},
    ]);
    final data = jsonDecode(result.body) as List?;
    if ((data?.isNotEmpty ?? false) &&
        data!.firstOrNull?["result"] != "not_found") {
      final node = data.firstOrNull;
      if (node?["list"] is String) {
        track.status = _trackFromSimklStatus(node!["list"]);
        if (track.status == TrackStatus.completed &&
            node?["last_watched_at"] is String) {
          track.finishedReadingDate = DateTime.tryParse(
            node!["last_watched_at"],
          )?.millisecondsSinceEpoch;
        }
      }
      if (node?["episodes_watched"] is num) {
        track.lastChapterRead = (node!["episodes_watched"] as num).toInt();
      }
      if (node?["episodes_total"] is num) {
        track.totalChapter = (node!["episodes_total"] as num).toInt();
      }
      track.libraryId = 1;
      if (node?["result"] == false) {
        track.libraryId = 0;
        return await update(track, isManga);
      }
    }
    return track;
  });

  @override
  Future<List<TrackSearch>> search(String query, bool isManga) => _withSession((
    oAuth,
  ) async {
    final urlMovies = Uri.parse(
      '$_baseApiUrl/search/movies',
    ).replace(queryParameters: {'q': query, 'extended': 'full', 'limit': '15'});
    final resultMovies = await _makeGetRequest(urlMovies, oAuth);
    final dataMovies = jsonDecode(resultMovies.body) as List?;
    final movies =
        dataMovies?.map((e) {
          return TrackSearch(
            mediaId: e['ids']?['simkl_id'] ?? e['ids']?['simkl'],
            summary: e['overview'] ?? 'No summary available.',
            totalChapter: 0,
            coverUrl: e['poster'] != null
                ? 'https://wsrv.nl/?url=https://simkl.in/posters/${e['poster']}_m.webp'
                : '',
            title: e['title'] ?? 'Unknown Title',
            score: (e["ratings"]?["simkl"]?["rating"] as num?)?.toDouble(),
            startDate: e["release_date"] ?? "",
            publishingType: "movie",
            publishingStatus: e["status"],
            trackingUrl:
                "https://simkl.com/movie/${e['ids']?['simkl_id'] ?? e['ids']?['simkl']}",
            syncId: syncId,
          );
        }).toList() ??
        [];
    final urlSeries = Uri.parse(
      '$_baseApiUrl/search/${_searchType(isManga)}',
    ).replace(queryParameters: {'q': query, 'extended': 'full', 'limit': '15'});
    final resultSeries = await _makeGetRequest(urlSeries, oAuth);
    final dataSeries = jsonDecode(resultSeries.body) as List?;
    final series =
        dataSeries?.map((e) {
          return TrackSearch(
            mediaId: e['ids']?['simkl_id'] ?? e['ids']?['simkl'],
            summary: e['overview'] ?? 'No summary available.',
            totalChapter: 0,
            coverUrl: e['poster'] != null
                ? 'https://wsrv.nl/?url=https://simkl.in/posters/${e['poster']}_m.webp'
                : '',
            title: e['title'] ?? 'Unknown Title',
            score: (e["ratings"]?["simkl"]?["rating"] as num?)?.toDouble(),
            startDate: e["release_date"] ?? "",
            publishingType: _searchType(isManga),
            publishingStatus: e["status"],
            trackingUrl:
                "https://simkl.com/${_searchType(isManga)}/${e['ids']?['simkl_id'] ?? e['ids']?['simkl']}",
            syncId: syncId,
          );
        }).toList() ??
        [];
    return movies + series;
  });

  @override
  List<TrackStatus> statusList(bool isManga) => [
    TrackStatus.watching,
    TrackStatus.completed,
    TrackStatus.onHold,
    TrackStatus.dropped,
    TrackStatus.planToWatch,
  ];

  @override
  Future<Track> update(Track track, bool isManga) => _withSession((
    oAuth,
  ) async {
    final existRemote = track.libraryId == 1;
    final isMovie =
        track.trackingUrl?.replaceAll("https://simkl.com/", "").split("/")[0] ==
        "movie";
    final url = Uri.parse(
      existRemote
          ? "$_baseApiUrl/sync/history"
          : "$_baseApiUrl/sync/add-to-list",
    ).replace(queryParameters: {'extended': 'full', 'limit': '15'});
    final body = isMovie
        ? {
            'movies': [
              {
                if (!existRemote) 'to': _trackToSimklStatus(track),
                if (existRemote) 'status': _trackToSimklStatus(track),
                'ids': {'simkl': track.mediaId},
              },
            ],
          }
        : {
            'shows': [
              {
                if (!existRemote) 'to': _trackToSimklStatus(track),
                if (existRemote) 'status': _trackToSimklStatus(track),
                'ids': {'simkl': track.mediaId},
                'episodes': [
                  for (int i = 1; i <= (track.lastChapterRead ?? 1); i++)
                    {'number': i},
                ],
              },
            ],
          };
    final result = await _makePostRequest(url, oAuth, body);
    track.libraryId = 1;
    if (result.statusCode == 201) {
      return track;
    }
    final temp = (jsonDecode(result.body) as Map<String, dynamic>?)?["added"];
    final data = _extractTrackData(
      temp?[isMovie ? "movies" : "shows"] as List?,
      track.mediaId,
    );
    return _parseTrack(track, data);
  });

  Map<String, dynamic>? _extractTrackData(List? data, int? mediaId) {
    return data?.firstWhereOrNull((e) => e["ids"]?["simkl"] == mediaId);
  }

  Track _parseTrack(Track track, Map<String, dynamic>? data) {
    if (data?["to"] is String) {
      track.status = _trackFromSimklStatus(data!["to"]);
    }
    return track;
  }

  String _trackToSimklStatus(Track track) => switch (track.status) {
    TrackStatus.completed => "completed",
    TrackStatus.watching => "watching",
    TrackStatus.onHold => "hold",
    TrackStatus.dropped => "dropped",
    _ => "plantowatch",
  };

  TrackStatus _trackFromSimklStatus(String status) => switch (status) {
    "completed" => TrackStatus.completed,
    "watching" => TrackStatus.watching,
    "hold" => TrackStatus.onHold,
    "dropped" => TrackStatus.dropped,
    _ => TrackStatus.planToWatch,
  };

  bool _unchanged(String? expected) =>
      ref.mounted && _repository.getPreferenceById(syncId)?.oAuth == expected;

  // Check inside the existing DB queue: a queued logout/account switch wins
  // over an authorization response that arrives later.
  Future<bool> _replace(String? expected, TrackPreference? next) async {
    final saved = await _repository.writeTransaction(() {
      if (!_unchanged(expected)) return false;
      if (next == null) {
        _repository.deletePreferenceSync(syncId);
      } else {
        _repository.putAllPreferencesSync([next]);
      }
      return true;
    });
    if (saved && ref.mounted) ref.invalidate(tracksProvider(syncId: syncId));
    return saved;
  }

  bool _validOAuth(OAuth value) =>
      value.clientId == _clientId &&
      value.tokenType?.toLowerCase() == 'bearer' &&
      value.accessToken?.isNotEmpty == true &&
      value.refreshToken?.isNotEmpty == true &&
      (value.expiresIn ?? 0) > 0 &&
      value.scope?.split(' ').toSet().containsAll(_scope.split(' ')) == true;

  OAuth _storedOAuth(TrackPreference? preference) {
    if (preference?.oAuth == null ||
        (int.tryParse(preference?.username ?? '') ?? 0) <= 0) {
      throw StateError('Simkl login required');
    }
    final value = OAuth.fromJson(jsonDecode(preference!.oAuth!));
    if (!_validOAuth(value)) throw StateError('Simkl login required');
    return value;
  }

  void _requireGrant(OAuth expected) {
    if (!ref.mounted ||
        _storedOAuth(_repository.getPreferenceById(syncId)).refreshToken !=
            expected.refreshToken) {
      throw StateError('Simkl account changed');
    }
  }

  Future<OAuth> _getOAuthForRequest({
    OAuth? expected,
    bool force = false,
  }) async {
    if (!ref.mounted) throw StateError('Simkl session closed');
    final preference = _repository.getPreferenceById(syncId);
    late final OAuth current;
    try {
      current = _storedOAuth(preference);
    } catch (_) {
      if (preference != null) await _replace(preference.oAuth, null);
      rethrow;
    }
    if (expected != null && current.refreshToken != expected.refreshToken) {
      throw StateError('Simkl account changed');
    }
    final key = (_repository, syncId, current.refreshToken!);
    if (!_refreshes.containsKey(key) &&
        current.expiresIn! > DateTime.now().millisecondsSinceEpoch + 30000 &&
        (!force || current.accessToken != expected?.accessToken)) {
      return current;
    }
    final pending = _refreshes[key] ??= _refresh(preference!, current)
        .whenComplete(() {
          _refreshes.remove(key);
        });
    final refreshed = await pending;
    _requireGrant(refreshed);
    return refreshed;
  }

  Future<OAuth> _refresh(TrackPreference previous, OAuth current) async {
    final keepAlive = ref.keepAlive();
    try {
      _requireGrant(current);
      final refreshed = await _token({
        'grant_type': 'refresh_token',
        'refresh_token': current.refreshToken!,
      }, previous.oAuth);
      if (refreshed.refreshToken != current.refreshToken) {
        throw StateError('Unexpected Simkl grant');
      }
      final next = TrackPreference.fromJson(previous.toJson())
        ..oAuth = jsonEncode(refreshed.toJson())
        ..refreshing = false;
      if (!await _replace(previous.oAuth, next)) {
        throw StateError('Simkl account changed');
      }
      return refreshed;
    } on _SimklTokenException catch (error) {
      if (error.invalidGrant) await _replace(previous.oAuth, null);
      rethrow;
    } finally {
      keepAlive.close();
    }
  }

  Future<OAuth> _token(Map<String, String> grant, String? expected) async {
    final version = (await PackageInfo.fromPlatform()).version;
    if (!_unchanged(expected)) throw StateError('Simkl account changed');
    final response = await http.post(
      _identified(Uri.parse('$_baseApiUrl/oauth2/token'), version),
      headers: {'User-Agent': '${NodeLaneBrand.userAgent}/$version'},
      body: {'client_id': _clientId, ...grant},
    );
    if (response.statusCode != 200) {
      var invalidGrant = false;
      if (response.statusCode == 400) {
        try {
          invalidGrant =
              (jsonDecode(response.body) as Map)['error'] == 'invalid_grant';
        } catch (_) {}
      }
      throw _SimklTokenException(invalidGrant);
    }
    final result = OAuth.fromJson(jsonDecode(response.body));
    if ((result.expiresIn ?? 0) <= 0) {
      throw StateError('Invalid Simkl token lifetime');
    }
    result
      ..clientId = _clientId
      ..expiresIn =
          DateTime.now().millisecondsSinceEpoch + result.expiresIn! * 1000;
    if (!_validOAuth(result)) throw StateError('Invalid Simkl authorization');
    return result;
  }

  Uri _identified(Uri url, String version) => url.replace(
    queryParameters: {
      ...url.queryParameters,
      'client_id': _clientId,
      'app-name': NodeLaneBrand.userAgent,
      'app-version': version,
    },
  );

  Future<Response> _send(
    Uri url,
    String token, {
    Object? body,
    void Function()? check,
  }) async {
    final version = (await PackageInfo.fromPlatform()).version;
    if (!ref.mounted) throw StateError('Simkl session closed');
    check?.call();
    final headers = {
      'Authorization': 'Bearer $token',
      'User-Agent': '${NodeLaneBrand.userAgent}/$version',
      'Content-Type': 'application/json',
    };
    return body == null
        ? http.get(_identified(url, version), headers: headers)
        : http.post(
            _identified(url, version),
            headers: headers,
            body: jsonEncode(body),
          );
  }

  void _requireSuccess(Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw StateError('Simkl request failed (${response.statusCode})');
    }
  }

  Future<Response> _request(Uri url, OAuth expected, {Object? body}) async {
    var current = await _getOAuthForRequest(expected: expected);
    var response = await _send(
      url,
      current.accessToken!,
      body: body,
      check: () => _requireGrant(current),
    );
    _requireGrant(current);
    if (response.statusCode == 401) {
      // Re-read before refreshing: another family instance may already have
      // replaced the rejected token. Retry an explicit auth rejection once;
      // never replay a write after a transport failure or an unknown result.
      current = await _getOAuthForRequest(expected: current, force: true);
      response = await _send(
        url,
        current.accessToken!,
        body: body,
        check: () => _requireGrant(current),
      );
      _requireGrant(current);
    }
    _requireSuccess(response);
    return response;
  }

  Future<Response> _makeGetRequest(Uri url, OAuth oAuth) =>
      _request(url, oAuth);

  Future<Response> _makePostRequest(Uri url, OAuth oAuth, Object body) =>
      _request(url, oAuth, body: body);

  @override
  String displayScore(int score) {
    throw UnimplementedError();
  }

  @override
  (int, int) getScoreValue() {
    throw UnimplementedError();
  }

  @override
  Future<bool> checkRefresh() async {
    try {
      await _getOAuthForRequest();
      return true;
    } catch (_) {
      return false;
    }
  }
}

class _SimklTokenException implements Exception {
  const _SimklTokenException(this.invalidGrant);
  final bool invalidGrant;
}
