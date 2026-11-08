import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:mangayomi/utils/url_protocol/protocol.dart' show appUrlScheme;
import 'package:http_interceptor/http_interceptor.dart';
import 'package:intl/intl.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/models/track_search.dart';
import 'package:mangayomi/modules/more/settings/track/myanimelist/model.dart';
import 'package:mangayomi/modules/more/settings/track/providers/track_providers.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/utils/log/logger.dart';

import 'base_tracker.dart';
import 'expiring_oauth_tracker.dart';
import 'oauth_browser.dart';
import 'tracker_account.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'myanimelist.g.dart';

@riverpod
class MyAnimeList extends _$MyAnimeList
    with ExpiringOAuthTracker
    implements BaseTracker {
  MyAnimeList({Client? client})
    : http = client ?? MClient.init(reqcopyWith: {'useDartHttpClient': true});

  final Client http;
  static const _baseOAuthUrl = 'https://myanimelist.net/v1/oauth2';
  static const _baseApiUrl = 'https://api.myanimelist.net/v2';
  static const _redirectUri = '$appUrlScheme://myanimelist-auth';
  Future<bool>? _loginFuture;
  final _browser = TrackerOAuthBrowser();

  String get _clientId => switch (defaultTargetPlatform) {
    TargetPlatform.iOS => '79c9fc22f3d141372e12b62e48ffddfd',
    TargetPlatform.android => '8205c12a0bef7f51110aa5ba5bcc8533',
    _ => 'd3e6963529b9fe709b42e6dc3eb24856',
  };

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
    final clientId = _clientId;
    final keepAlive = ref.keepAlive();
    try {
      final verifier = _randomToken();
      final state = _randomToken();
      final authorization = Uri.parse('$_baseOAuthUrl/authorize').replace(
        queryParameters: {
          'client_id': clientId,
          'redirect_uri': _redirectUri,
          'response_type': 'code',
          'code_challenge': verifier,
          'code_challenge_method': 'plain',
          'state': state,
        },
      );
      final started = DateTime.now();
      final returned = await _browser.authenticate(
        authorization,
        callbackHost: 'myanimelist-auth',
      );
      if (!ref.mounted ||
          DateTime.now().difference(started) > const Duration(minutes: 10) ||
          returned.scheme != appUrlScheme ||
          returned.authority != 'myanimelist-auth' ||
          returned.path.isNotEmpty ||
          returned.hasFragment) {
        return false;
      }
      final params = returned.queryParametersAll;
      final codes = params['code'];
      final states = params['state'];
      if (params.containsKey('error') ||
          codes == null ||
          codes.length != 1 ||
          codes.single.isEmpty ||
          states == null ||
          states.length != 1 ||
          states.single != state) {
        return false;
      }

      final oAuth = await _getOAuth(codes.single, verifier, clientId);
      if (!ref.mounted) return false;
      final username = await _getUserName(oAuth.accessToken!);
      _saveOAuth(username, oAuth);

      return true;
    } catch (_) {
      return false;
    } finally {
      keepAlive.close();
    }
  }

  @override
  String get trackerName => "MyAnimeList";

  @override
  Future<void> saveRefreshedOAuth(OAuth oAuth) async =>
      _saveOAuth(await _getUserName(oAuth.accessToken!), oAuth);

  @override
  Future<OAuth?> refreshOAuth(OAuth oldOAuth) async {
    final clientId = _clientId;
    if (oldOAuth.clientId != clientId ||
        oldOAuth.refreshToken?.isNotEmpty != true) {
      return null;
    }
    final response = await http.post(
      Uri.parse('$_baseOAuthUrl/token'),
      body: {
        'client_id': clientId,
        'grant_type': 'refresh_token',
        'refresh_token': oldOAuth.refreshToken!,
      },
    );
    if (response.statusCode != 200) return null;
    return _readOAuth(response, clientId);
  }

  @override
  Future<String> getAccessToken({bool bypass = false}) async {
    final track = ref.read(tracksProvider(syncId: syncId));
    OAuth? oauth;
    try {
      oauth = OAuth.fromJson(jsonDecode(track?.oAuth ?? '{}'));
    } catch (_) {
      // Invalid or foreign credentials must never reach the API.
    }
    if (oauth?.clientId != _clientId ||
        oauth?.accessToken?.isNotEmpty != true ||
        oauth?.expiresIn == null) {
      ref.read(tracksProvider(syncId: syncId).notifier).logout();
      throw StateError('MyAnimeList login required');
    }
    return super.getAccessToken(bypass: bypass);
  }

  void _saveOAuth(TrackerAccount user, OAuth oAuth) {
    if (!ref.mounted) throw StateError('MyAnimeList login cancelled');
    ref
        .read(tracksProvider(syncId: syncId).notifier)
        .login(
          TrackPreference(
            syncId: syncId,
            username: user.id,
            displayName: user.name,
            avatarUrl: user.avatarUrl,
            prefs: "",
            oAuth: jsonEncode(oAuth.toJson()),
          ),
        );
  }

  @override
  Future<List<TrackSearch>> search(String query, isManga) async {
    final accessToken = await getAccessToken();
    final url = Uri.parse('$_baseApiUrl/${isManga ? "manga" : "anime"}')
        .replace(queryParameters: {'q': query.trim(), 'nsfw': 'true'});
    final result = await _makeGetRequest(url, accessToken);
    final res = jsonDecode(result.body) as Map<String, dynamic>;

    List<int> mangaIds = res['data'] == null
        ? []
        : (res['data'] as List).map((e) => e['node']["id"] as int).toList();
    final trackSearchResult = await Future.wait(
      mangaIds.map((id) => getDetails(id, accessToken, isManga)),
    );

    return trackSearchResult
        .where((element) => !element.publishingType!.contains("novel"))
        .toList();
  }

  Future<TrackSearch> getDetails(
    int id,
    String accessToken,
    bool isManga,
  ) async {
    final item = isManga ? "manga" : "anime";
    final contentUnit = isManga ? "num_chapters" : "num_episodes";
    final url = Uri.parse('$_baseApiUrl/$item/$id').replace(
      queryParameters: {
        'fields':
            'id,title,synopsis,$contentUnit,main_picture,status,media_type,start_date,mean',
      },
    );

    final result = await _makeGetRequest(url, accessToken);
    final res = jsonDecode(result.body) as Map<String, dynamic>;

    return TrackSearch(
      mediaId: res["id"],
      summary: res["synopsis"] ?? "",
      totalChapter: res[contentUnit],
      coverUrl: res["main_picture"]?["large"] ?? "",
      title: res["title"],
      startDate: res["start_date"] ?? "",
      publishingType: res["media_type"].toString().replaceAll("_", " "),
      publishingStatus: res["status"].toString().replaceAll("_", " "),
      trackingUrl: "https://myanimelist.net/$item/${res["id"]}",
      score: (res["mean"] as num?)?.toDouble(),
      syncId: syncId,
    );
  }

  @override
  Future<List<TrackSearch>> fetchGeneralData({
    bool isManga = true,
    String rankingType = "airing",
  }) async {
    final accessToken = await getAccessToken();
    final item = isManga ? "manga" : "anime";
    final contentUnit = isManga ? "num_chapters" : "num_episodes";
    final url = Uri.parse('$_baseApiUrl/$item/ranking').replace(
      queryParameters: {
        'ranking_type': rankingType,
        'limit': '15',
        'fields':
            'id,title,synopsis,$contentUnit,main_picture,status,media_type,start_date,mean',
      },
    );
    final result = await _makeGetRequest(url, accessToken);
    final res = jsonDecode(result.body) as Map<String, dynamic>;

    return res['data'] == null
        ? []
        : (res['data'] as List).map((e) {
            final node = e["node"] as Map<String, dynamic>;
            String clean(String? s) => (s ?? '').replaceAll('_', ' ');
            return TrackSearch(
              mediaId: node["id"],
              summary: node["synopsis"] ?? "",
              totalChapter: node[contentUnit],
              coverUrl: node["main_picture"]?["large"] ?? "",
              title: node["title"],
              score: (node["mean"] as num?)?.toDouble(),
              startDate: node["start_date"] ?? "",
              publishingType: clean(node["media_type"].toString()),
              publishingStatus: clean(node["status"].toString()),
              trackingUrl: "https://myanimelist.net/$item/${node["id"]}",
              syncId: syncId,
            );
          }).toList();
  }

  @override
  Future<List<TrackSearch>> fetchUserData({bool isManga = true}) async {
    final accessToken = await getAccessToken();
    final item = isManga ? "mangalist" : "animelist";
    final contentUnit = isManga ? "num_chapters" : "num_episodes";
    final currentStatus = isManga ? "reading" : "watching";
    final url = Uri.parse('$_baseApiUrl/users/@me/$item').replace(
      queryParameters: {
        'status': currentStatus,
        utf8.decode([110, 115, 102, 119]): 'true',
        'sort': 'list_updated_at',
        'limit': '1000',
        'fields':
            'id,title,synopsis,$contentUnit,main_picture,status,media_type,start_date,mean,list_status',
      },
    );
    final result = await _makeGetRequest(url, accessToken);
    final res = jsonDecode(result.body) as Map<String, dynamic>;

    return res['data'] == null
        ? []
        : (res['data'] as List).map((e) {
            final node = e["node"] as Map<String, dynamic>;
            final listStatus = e["list_status"] as Map<String, dynamic>;
            String clean(String? s) => (s ?? '').replaceAll('_', ' ');
            return TrackSearch(
              mediaId: node["id"],
              summary: node["synopsis"] ?? "",
              totalChapter: node[contentUnit],
              coverUrl: node["main_picture"]?["large"] ?? "",
              title: node["title"],
              score: (node["mean"] as num?)?.toDouble(),
              startDate: node["start_date"] ?? "",
              publishingType: clean(node["media_type"].toString()),
              publishingStatus: clean(node["status"].toString()),
              trackingUrl: "https://myanimelist.net/$item/${node["id"]}",
              startedReadingDate: _parseDate(listStatus["start_date"]),
              finishedReadingDate: _parseDate(listStatus["finish_date"]),
              lastChapterRead:
                  listStatus[isManga
                      ? "num_chapters_read"
                      : "num_episodes_watched"],
              status: fromMyAnimeListStatus(listStatus["status"], isManga).name,
              syncId: syncId,
            );
          }).toList();
  }

  String _convertToIsoDate(int? epochTime) {
    String date = "";
    try {
      date = DateFormat(
        "yyyy-MM-dd",
        "en_US",
      ).format(DateTime.fromMillisecondsSinceEpoch(epochTime!));
    } catch (_) {}
    return date;
  }

  String _randomToken() {
    final random = Random.secure();
    final values = List<int>.generate(32, (_) => random.nextInt(256));
    return base64UrlEncode(values).replaceAll('=', '');
  }

  TrackStatus _getMALTrackStatus(String status, bool isManga) {
    return switch (status) {
      "reading" when isManga => TrackStatus.reading,
      "watching" when !isManga => TrackStatus.watching,
      "completed" => TrackStatus.completed,
      "on_hold" => TrackStatus.onHold,
      "dropped" => TrackStatus.dropped,
      "plan_to_read" when isManga => TrackStatus.planToRead,
      "plan_to_watch" when !isManga => TrackStatus.planToWatch,
      _ => isManga ? TrackStatus.reReading : TrackStatus.planToWatch,
    };
  }

  @override
  List<TrackStatus> statusList(bool isManga) => [
    isManga ? TrackStatus.reading : TrackStatus.watching,
    TrackStatus.completed,
    TrackStatus.onHold,
    TrackStatus.dropped,
    isManga ? TrackStatus.planToRead : TrackStatus.planToWatch,
    if (isManga) TrackStatus.reReading,
  ];

  String? toMyAnimeListStatus(TrackStatus status, bool isManga) {
    return switch (status) {
      TrackStatus.reading when isManga => "reading",
      TrackStatus.watching when !isManga => "watching",
      TrackStatus.completed => "completed",
      TrackStatus.onHold => "on_hold",
      TrackStatus.dropped => "dropped",
      TrackStatus.planToRead when isManga => "plan_to_read",
      TrackStatus.planToWatch when !isManga => "plan_to_watch",
      _ => isManga ? "reading" : "plan_to_watch",
    };
  }

  TrackStatus fromMyAnimeListStatus(String status, bool isManga) {
    return switch (status) {
      "reading" when isManga => TrackStatus.reading,
      "watching" when !isManga => TrackStatus.watching,
      "completed" => TrackStatus.completed,
      "on_hold" => TrackStatus.onHold,
      "dropped" => TrackStatus.dropped,
      "plan_to_read" when isManga => TrackStatus.planToRead,
      "plan_to_watch" when !isManga => TrackStatus.planToWatch,
      _ => isManga ? TrackStatus.reading : TrackStatus.planToWatch,
    };
  }

  Future<OAuth> _getOAuth(String code, String verifier, String clientId) async {
    final params = {
      'client_id': clientId,
      'code': code,
      'code_verifier': verifier,
      'grant_type': 'authorization_code',
      'redirect_uri': _redirectUri,
    };
    final response = await http.post(
      Uri.parse('$_baseOAuthUrl/token'),
      body: params,
    );
    return _readOAuth(response, clientId);
  }

  OAuth _readOAuth(Response response, String clientId) {
    if (response.statusCode != 200) {
      throw StateError('MyAnimeList authorization failed');
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final oauth = OAuth.fromJson(data);
    if (oauth.tokenType?.toLowerCase() != 'bearer' ||
        oauth.accessToken?.isNotEmpty != true ||
        oauth.refreshToken?.isNotEmpty != true ||
        (oauth.expiresIn ?? 0) <= 0) {
      throw const FormatException('Invalid MyAnimeList token response');
    }
    return buildExpiringOAuth(data, clientId);
  }

  /// The account behind the token.
  ///
  /// `/users/@me` already answers with `picture`, so the avatar costs nothing
  /// beyond reading a field that was being thrown away.
  Future<TrackerAccount> _getUserName(String accessToken) async {
    final response = await _makeGetRequest(
      Uri.parse('$_baseApiUrl/users/@me'),
      accessToken,
    );
    if (response.statusCode != 200) {
      throw StateError('MyAnimeList account verification failed');
    }
    final account = malAccount(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
    if (account.id.trim().isEmpty) {
      throw const FormatException('Invalid MyAnimeList account');
    }
    return account;
  }

  @override
  Future<Track?> findLibItem(Track track, bool isManga) async {
    final type = isManga ? "manga" : "anime";
    final contentUnit = isManga ? 'num_chapters' : 'num_episodes';
    final accessToken = await getAccessToken();
    final uri = Uri.parse('$_baseApiUrl/$type/${track.mediaId}').replace(
      queryParameters: {
        'fields': '$contentUnit,my_list_status{start_date,finish_date}',
      },
    );
    final response = await _makeGetRequest(uri, accessToken);
    final mJson = jsonDecode(response.body);
    track.totalChapter = mJson[contentUnit] ?? 0;
    if (mJson['my_list_status'] != null) {
      track = _parseItem(mJson["my_list_status"], track, isManga);
    } else {
      track = await update(track, isManga);
    }
    return track;
  }

  Track _parseItem(Map<String, dynamic> mJson, Track track, bool isManga) {
    bool isRepeating =
        mJson[isManga ? "is_rereading" : "is_rewatching"] ?? false;
    track.status = isRepeating
        ? (isManga ? TrackStatus.reReading : TrackStatus.reWatching)
        : _getMALTrackStatus(mJson["status"], isManga);
    track.lastChapterRead = int.parse(
      mJson[isManga ? "num_chapters_read" : "num_episodes_watched"].toString(),
    );
    track.score = int.parse(mJson["score"].toString());
    track.startedReadingDate = _parseDate(mJson["start_date"]);
    track.finishedReadingDate = _parseDate(mJson["finish_date"]);
    return track;
  }

  int? _parseDate(String? isoDate) {
    if (isoDate == null) return null;

    final date = DateFormat('yyyy-MM-dd', 'en_US').parse(isoDate);
    return date.millisecondsSinceEpoch;
  }

  @override
  Future<Track> update(Track track, bool isManga) async {
    final accessToken = await getAccessToken();
    final formBody = {
      'status':
          (toMyAnimeListStatus(track.status, isManga) ??
                  (isManga ? 'reading' : 'watching'))
              .toString(),
      isManga ? 'is_rereading' : 'is_rewatching':
          (track.status ==
                  (isManga ? TrackStatus.reReading : TrackStatus.reWatching))
              .toString(),
      if (track.score != null && track.score! > 0)
        'score': track.score.toString(),
      isManga ? 'num_chapters_read' : 'num_watched_episodes': track
          .lastChapterRead
          .toString(),
      if ((track.startedReadingDate ?? 0) > 0)
        'start_date': _convertToIsoDate(track.startedReadingDate),
      if ((track.finishedReadingDate ?? 0) > 0)
        'finish_date': _convertToIsoDate(track.finishedReadingDate),
    };
    final request = Request(
      'PUT',
      Uri.parse(
        '$_baseApiUrl/${isManga ? "manga" : "anime"}'
        '/${track.mediaId}/my_list_status',
      ),
    );
    request.bodyFields = formBody;
    request.headers.addAll({'Authorization': 'Bearer $accessToken'});
    final response = await Client().send(request);
    final bodyStr = await response.stream.bytesToString();
    if (response.statusCode != 200) {
      AppLogger.log(
        "MAL update failed (${response.statusCode}): $bodyStr",
        logLevel: LogLevel.error,
      );
      throw Exception("Failed to update MAL entry: ${response.statusCode}");
    }
    final mJson = jsonDecode(bodyStr);
    return _parseItem(mJson, track, isManga);
  }

  Future<Response> _makeGetRequest(Uri url, String accessToken) async {
    return await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );
  }

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
    final keepAlive = ref.keepAlive();
    try {
      await getAccessToken(bypass: true);
      return true;
    } catch (_) {
      return false;
    } finally {
      if (ref.mounted) {
        ref.read(tracksProvider(syncId: syncId).notifier).setRefreshing(false);
      }
      keepAlive.close();
    }
  }
}
