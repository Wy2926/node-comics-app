import 'dart:async';
import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:crypto/crypto.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/repositories/track_repository.dart';
import 'package:mangayomi/repositories/db_write_queue.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/modules/more/settings/track/myanimelist/model.dart';
import 'package:mangayomi/modules/more/settings/track/providers/track_providers.dart';
import 'package:mangayomi/services/trackers/anilist.dart';
import 'package:mangayomi/services/trackers/myanimelist.dart';
import 'package:mangayomi/services/trackers/simkl.dart';
import 'package:mangayomi/services/trackers/tracker_account.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  PackageInfo.setMockInitialValues(
    appName: 'NodeLane Comics',
    packageName: 'com.nodelane.comics',
    version: '0.1.0',
    buildNumber: '1',
    buildSignature: '',
  );
  group('AniList', () {
    test('survives an account with no avatar set', () {
      final account = anilistAccount({
        'id': 7,
        'name': 'someone',
        'avatar': null,
      });

      expect(account.id, '7');
      expect(account.name, 'someone');
      expect(account.avatarUrl, isNull);
    });
  });

  group('MyAnimeList', () {
    test('reads no picture as no picture rather than an empty URL', () {
      // An empty string here would be handed to an image provider and drawn
      // as a broken image.
      expect(malAccount({'name': 'someone', 'picture': ''}).avatarUrl, isNull);
      expect(malAccount({'name': 'someone'}).avatarUrl, isNull);
    });
  });

  group('Simkl AUTH V2', () {
    const webAuth = MethodChannel('flutter_web_auth_2');
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    late _SimklRepository repository;
    late ProviderContainer container;
    late Simkl tracker;
    late Future<http.Response> Function(http.Request) respond;
    late Future<String> Function(Uri) authorize;
    late List<http.Request> requests;
    late List<Uri> authorizations;

    String callback(Uri uri, {Map<String, String>? changes}) =>
        Uri.parse('nodelane-comics://simkl-auth')
            .replace(
              queryParameters: {
                'code': 'one-use-code',
                'state': uri.queryParameters['state']!,
                'iss': 'https://simkl.com',
                ...?changes,
              },
            )
            .toString();

    Simkl anotherTracker() {
      final provider = simklProvider(
        syncId: 4,
        itemType: null,
        widgetRef: Object(),
      );
      container.listen(provider, (_, _) {});
      return container.read(provider.notifier);
    }

    setUp(() {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      repository = _SimklRepository();
      requests = [];
      authorizations = [];
      authorize = (uri) async => callback(uri);
      respond = (request) async => switch (request.url.path) {
        '/oauth2/token' => http.Response(jsonEncode(_simklToken()), 200),
        '/users/settings' => http.Response(
          jsonEncode({
            'account': {'id': 4242},
            'user': {'name': 'Someone'},
          }),
          200,
        ),
        '/sync/all-items/anime' => http.Response('{"anime":[]}', 200),
        _ => throw StateError('Unexpected Simkl request'),
      };
      final client = MockClient((request) async {
        requests.add(request);
        expect(request.url.host, 'api.simkl.com');
        expect(request.url.queryParameters['client_id'], _simklClientId);
        expect(request.url.queryParameters['app-name'], 'nodelane-comics');
        expect(request.url.queryParameters['app-version'], '0.1.0');
        expect(request.url.queryParameters, isNot(contains('clientId')));
        expect(request.headers['User-Agent'], 'nodelane-comics/0.1.0');
        expect(request.headers, isNot(contains('simkl-api-key')));
        return respond(request);
      });
      container = ProviderContainer(
        overrides: [
          tracksProvider(syncId: 4).overrideWith(_MemoryTracks.new),
          simklProvider.overrideWith(
            () => Simkl(client: client, repository: repository),
          ),
        ],
      );
      tracker = anotherTracker();
      messenger.setMockMethodCallHandler(webAuth, (call) async {
        if (call.method != 'authenticate') return null;
        expect(call.arguments['callbackUrlScheme'], 'nodelane-comics');
        final uri = Uri.parse(call.arguments['url'] as String);
        authorizations.add(uri);
        return authorize(uri);
      });
    });
    tearDown(() {
      container.dispose();
      debugDefaultTargetPlatformOverride = null;
      messenger.setMockMethodCallHandler(webAuth, null);
    });

    test(
      'deduplicates login, binds S256 code exchange and verifies the account',
      () async {
        final first = tracker.login();
        expect(identical(first, tracker.login()), isTrue);
        expect(await first, isTrue);
        final authorization = authorizations.single;
        expect(
          authorization.origin + authorization.path,
          'https://simkl.com/oauth2/authorize',
        );
        final query = authorization.queryParameters;
        expect(query['client_id'], _simklClientId);
        expect(query['redirect_uri'], 'nodelane-comics://simkl-auth');
        expect(query['scope'], 'media:read media:write');
        expect(query['code_challenge_method'], 'S256');
        final body = Uri.splitQueryString(requests.first.body);
        expect(
          body.keys,
          unorderedEquals([
            'client_id',
            'grant_type',
            'code',
            'code_verifier',
            'redirect_uri',
          ]),
        );
        expect(body['client_id'], _simklClientId);
        expect(body['redirect_uri'], query['redirect_uri']);
        expect(body['grant_type'], 'authorization_code');
        expect(body['code'], 'one-use-code');
        expect(body['code_verifier'], hasLength(43));
        expect(
          query['code_challenge'],
          base64Url
              .encode(
                sha256.convert(ascii.encode(body['code_verifier']!)).bytes,
              )
              .replaceAll('=', ''),
        );
        final saved = repository.preference!;
        expect(saved.username, '4242');
        expect(saved.displayName, 'Someone');
        expect(saved.avatarUrl, isNull);
        final token = OAuth.fromJson(jsonDecode(saved.oAuth!));
        expect(token.clientId, _simklClientId);
        expect(token.scope, 'media:read media:write');
        expect(
          token.expiresIn,
          greaterThan(DateTime.now().millisecondsSinceEpoch),
        );
        expect(requests.last.headers['Authorization'], 'Bearer test-access');
        expect(await anotherTracker().checkRefresh(), isTrue);
        expect(requests, hasLength(2));
      },
    );

    test('rejects forged, ambiguous and denied callbacks before exchange; retry is fresh', () async {
      final invalid = <String Function(Uri)>[
        (uri) => callback(uri, changes: {'state': 'wrong'}),
        (uri) => callback(uri, changes: {'iss': 'https://other.example'}),
        (uri) => callback(uri).replaceFirst('iss=https%3A%2F%2Fsimkl.com', ''),
        (uri) => '${callback(uri)}&code=second',
        (uri) => '${callback(uri)}&state=second',
        (uri) => '${callback(uri)}&iss=https%3A%2F%2Fsimkl.com',
        (uri) => callback(uri, changes: {'error': 'access_denied'}),
        (uri) =>
            callback(uri).replaceFirst('://simkl-auth', '://simkl-auth/path'),
        (uri) => callback(uri).replaceFirst('://simkl-auth', '://other'),
        (uri) => '${callback(uri)}#unexpected',
      ];
      for (final makeCallback in invalid) {
        authorize = (uri) async => makeCallback(uri);
        expect(await tracker.login(), isFalse);
        expect(repository.preference, isNull);
      }
      expect(requests, isEmpty);
      authorize = (uri) async => callback(uri);
      expect(await tracker.login(), isTrue);
      expect(
        authorizations.map((uri) => uri.queryParameters['state']).toSet(),
        hasLength(invalid.length + 1),
      );
      expect(
        authorizations
            .map((uri) => uri.queryParameters['code_challenge'])
            .toSet(),
        hasLength(invalid.length + 1),
      );
    });

    test('refuses incomplete permissions, failed exchange and an unverified account', () async {
      final original = respond;
      for (final bad in [
        http.Response('{"error":"invalid_grant"}', 400),
        http.Response(jsonEncode(_simklToken()..['scope'] = 'media:read'), 200),
        http.Response(jsonEncode(_simklToken()..['expires_in'] = 0), 200),
        http.Response(jsonEncode(_simklToken()..remove('refresh_token')), 200),
      ]) {
        requests.clear();
        respond = (_) async => bad;
        expect(await tracker.login(), isFalse);
        expect(requests, hasLength(1));
        expect(repository.preference, isNull);
      }
      respond = (request) => request.url.path == '/users/settings'
          ? Future.value(
              http.Response('{"account":{},"user":{"name":"Someone"}}', 200),
            )
          : original(request);
      expect(await tracker.login(), isFalse);
      expect(repository.preference, isNull);
      respond = original;
      expect(await tracker.login(), isTrue);
    });

    test('expired restored credentials share one refresh across provider instances', () async {
      repository.preference = _simklPreference(expired: true);
      final entered = Completer<void>();
      final refresh = Completer<http.Response>();
      respond = (request) async {
        final body = Uri.splitQueryString(request.body);
        expect(body, {
          'client_id': _simklClientId,
          'grant_type': 'refresh_token',
          'refresh_token': 'test-refresh',
        });
        entered.complete();
        return refresh.future;
      };
      final first = tracker.checkRefresh();
      final second = anotherTracker().checkRefresh();
      await entered.future;
      refresh.complete(
        http.Response(jsonEncode(_simklToken(access: 'renewed')), 200),
      );
      expect(await Future.wait([first, second]), [true, true]);
      expect(requests, hasLength(1));
      expect(
        jsonDecode(repository.preference!.oAuth!)['access_token'],
        'renewed',
      );
      expect(repository.preference!.username, '4242');
      expect(await anotherTracker().checkRefresh(), isTrue);
      expect(requests, hasLength(1));
    });

    test('transient refresh failure keeps credentials; revoked grants require login', () async {
      final original = _simklPreference(expired: true);
      repository.preference = original;
      respond = (_) async => http.Response('unavailable', 503);
      expect(await tracker.checkRefresh(), isFalse);
      expect(repository.preference!.oAuth, original.oAuth);
      respond = (_) async => http.Response(jsonEncode(_simklToken()), 200);
      expect(await tracker.checkRefresh(), isTrue);
      repository.preference = original;
      respond = (_) async => http.Response('{"error":"invalid_grant"}', 400);
      expect(await tracker.checkRefresh(), isFalse);
      expect(repository.preference, isNull);
    });

    test('old application credentials never reach the network', () async {
      for (final old in [
        '{"access_token":"legacy"}',
        jsonEncode(
          jsonDecode(_simklPreference().oAuth!)
            ..['client_id'] = 'foreign-client',
        ),
      ]) {
        repository.preference = TrackPreference(
          syncId: 4,
          username: '4242',
          oAuth: old,
        );
        expect(await tracker.checkRefresh(), isFalse);
        expect(repository.preference, isNull);
      }
      expect(requests, isEmpty);
    });

    test('late login and refresh cannot overwrite a queued logout or account switch', () async {
      for (final isLogin in [true, false]) {
        for (final switchAccount in [false, true]) {
          repository.preference = _simklPreference(expired: !isLogin);
          final entered = Completer<void>();
          final returned = Completer<http.Response>();
          respond = (_) {
            entered.complete();
            return returned.future;
          };
          final pending = isLogin ? tracker.login() : tracker.checkRefresh();
          await entered.future;
          final replacement = switchAccount
              ? _simklPreference(refresh: 'another-grant')
              : null;
          // Do not await the write: it must win inside the actual queue.
          final changed = repository.writeTransaction(
            () => repository.preference = replacement,
          );
          returned.complete(
            http.Response(jsonEncode(_simklToken(access: 'late')), 200),
          );
          expect(await pending, isFalse);
          await changed;
          expect(repository.preference?.oAuth, replacement?.oAuth);
        }
      }
    });

    test('provider disposal discards a late token response', () async {
      final entered = Completer<void>();
      final returned = Completer<http.Response>();
      respond = (_) {
        entered.complete();
        return returned.future;
      };
      final pending = tracker.login();
      await entered.future;
      container.dispose();
      returned.complete(http.Response(jsonEncode(_simklToken()), 200));
      expect(await pending, isFalse);
      expect(repository.preference, isNull);
      expect(requests, hasLength(1));
    });

    test('401 retries once using a concurrently refreshed token', () async {
      repository.preference = _simklPreference();
      final entered = Completer<void>();
      final rejected = Completer<http.Response>();
      var apiCalls = 0;
      respond = (request) async {
        if (request.url.path == '/oauth2/token') {
          return http.Response(jsonEncode(_simklToken(access: 'renewed')), 200);
        }
        apiCalls++;
        if (apiCalls == 1) {
          entered.complete();
          return rejected.future;
        }
        expect(request.headers['Authorization'], 'Bearer renewed');
        return http.Response('{"anime":[]}', 200);
      };
      final pending = tracker.fetchUserData(isManga: false);
      await entered.future;
      repository.preference = _simklPreference(expired: true);
      expect(await anotherTracker().checkRefresh(), isTrue);
      rejected.complete(http.Response('{"error":"invalid_token"}', 401));
      expect(await pending, isEmpty);
      expect(
        requests.where((r) => r.url.path == '/oauth2/token'),
        hasLength(1),
      );
      expect(apiCalls, 2);
      respond = (request) async => request.url.path == '/oauth2/token'
          ? http.Response(jsonEncode(_simklToken(access: 'newer')), 200)
          : http.Response('{"error":"invalid_token"}', 401);
      requests.clear();
      await expectLater(
        tracker.fetchUserData(isManga: false),
        throwsStateError,
      );
      expect(requests, hasLength(3));
    });

    test('401 refresh holds unobserved callers until completion and then releases them', () async {
      repository.preference = _simklPreference();
      final entered = Completer<void>();
      final refreshed = Completer<http.Response>();
      var apiCalls = 0;
      respond = (request) async {
        if (request.url.path == '/oauth2/token') {
          entered.complete();
          return refreshed.future;
        }
        apiCalls++;
        if (apiCalls == 1) return http.Response('{}', 401);
        expect(request.headers['Authorization'], 'Bearer renewed');
        return http.Response('{"anime":[]}', 200);
      };
      final provider = simklProvider(
        syncId: 4,
        itemType: null,
        widgetRef: null,
      );
      final unobserved = container.read(provider.notifier);
      final first = unobserved.fetchUserData(isManga: false);
      await entered.future;
      final second = tracker.fetchUserData(isManga: false);
      await container.pump();
      expect(apiCalls, 1);
      expect(container.exists(provider), isTrue);
      refreshed.complete(
        http.Response(jsonEncode(_simklToken(access: 'renewed')), 200),
      );
      expect(await Future.wait([first, second]), [isEmpty, isEmpty]);
      expect(
        requests.where((r) => r.url.path == '/oauth2/token'),
        hasLength(1),
      );
      await container.pump();
      expect(container.exists(provider), isFalse);
    });

    test(
      'progress writes use V2 identity and do not repeat unknown outcomes',
      () async {
        repository.preference = _simklPreference();
        final track = Track(
          mediaId: 7,
          libraryId: 1,
          status: TrackStatus.watching,
          lastChapterRead: 2,
          trackingUrl: 'https://simkl.com/anime/7',
        );
        respond = (request) async {
          expect(request.method, 'POST');
          expect(request.url.path, '/sync/history');
          expect(request.headers['Authorization'], 'Bearer test-access');
          final body = jsonDecode(request.body);
          expect(body['shows'][0]['ids']['simkl'], 7);
          expect(body['shows'][0]['episodes'], [
            {'number': 1},
            {'number': 2},
          ]);
          return http.Response('{}', 201);
        };
        expect(await tracker.update(track, false), same(track));
        for (final fail in [false, true]) {
          requests.clear();
          respond = (_) async {
            if (fail) throw http.ClientException('Connection lost');
            return http.Response('unavailable', 503);
          };
          await expectLater(
            tracker.update(track, false),
            throwsA(anyOf(isA<Exception>(), isA<StateError>())),
          );
          expect(requests, hasLength(1));
        }
      },
    );

    test('search, discovery and library preserve anime routing', () async {
      repository.preference = _simklPreference();
      final anime = {
        'title': 'Anime',
        'ids': {'simkl': 7},
      };
      respond = (request) async {
        expect(request.headers['Authorization'], 'Bearer test-access');
        final data = switch (request.url.path) {
          '/search/anime' || '/anime/trending' => [anime],
          '/sync/all-items/anime' => {
            'anime': [
              {'show': anime},
            ],
          },
          '/sync/all-items/movies' => {'movies': []},
          '/search/movies' || '/search/tv' || '/movies/trending' => [],
          _ => throw StateError('Unexpected Simkl request'),
        };
        return http.Response(jsonEncode(data), 200);
      };
      for (final result in [
        await tracker.search('Anime', false),
        await tracker.fetchGeneralData(isManga: false),
        await tracker.fetchUserData(isManga: false),
      ]) {
        expect(result.single.mediaId, 7);
        expect(result.single.trackingUrl, 'https://simkl.com/anime/7');
      }
      await tracker.search('Movie', true);
      await tracker.fetchGeneralData(isManga: true);
      await tracker.fetchUserData(isManga: true);
      expect(requests.map((r) => r.url.path), [
        '/search/movies',
        '/search/anime',
        '/anime/trending',
        '/sync/all-items/anime',
        '/search/movies',
        '/search/tv',
        '/movies/trending',
        '/sync/all-items/movies',
      ]);
    });
  });

  group('Kitsu', () {
    test('falls back to the slug, which is readable, not the numeric id', () {
      final account = kitsuAccount({
        'id': '55555',
        'attributes': {
          'slug': 'some-one',
          'name': null,
          'ratingSystem': 'simple',
          'avatar': {'original': 'https://media.kitsu.io/users/avatars/1.png'},
        },
      });

      expect(account.id, '55555');
      expect(account.name, 'some-one');
      expect(account.avatarUrl, contains('kitsu.io'));
    });

    test('prefers the name when there is one', () {
      final account = kitsuAccount({
        'id': '1',
        'attributes': {'slug': 'some-one', 'name': 'Some One'},
      });

      expect(account.name, 'Some One');
      expect(account.avatarUrl, isNull);
    });
  });

  group('AniList login', () {
    const browser = MethodChannel('flutter_web_auth_2');
    const launcher = MethodChannel('plugins.flutter.io/url_launcher');
    const links = MethodChannel('com.llfbandit.app_links/events');
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    final provider = anilistProvider(syncId: 1, widgetRef: null);
    late ProviderContainer container;
    late _MemoryTracks tracks;
    late Anilist tracker;
    late Future<http.Response> Function(http.Request) viewer;
    late Future<String> Function(Uri) authenticate;
    final requests = <http.Request>[];
    final authorizations = <Uri>[];
    var linkCancels = 0;
    late Completer<void> listening;

    String callback(Uri authorization) => Uri(
      scheme: 'nodelane-comics',
      host: 'anilist-auth',
      fragment: Uri(
        queryParameters: {
          'access_token': 'test-access',
          'token_type': 'Bearer',
          'expires_in': '3600',
          'state': authorization.queryParameters['state']!,
        },
      ).query,
    ).toString();

    http.Response account() => http.Response(
      jsonEncode({
        'data': {
          'Viewer': {
            'id': 123,
            'name': 'Reader',
            'avatar': {'large': 'https://example.test/avatar.png'},
            'mediaListOptions': {'scoreFormat': 'POINT_10'},
          },
        },
      }),
      200,
    );

    void recordAuthorization(String url) {
      final uri = Uri.parse(url);
      expect(uri.origin, 'https://anilist.co');
      expect(uri.path, '/api/v2/oauth/authorize');
      expect(uri.queryParameters['client_id'], '55972');
      expect(
        uri.queryParameters.keys,
        unorderedEquals(['client_id', 'response_type', 'state']),
      );
      expect(uri.queryParameters['response_type'], 'token');
      expect(uri.queryParameters['state'], isNotEmpty);
      authorizations.add(uri);
    }

    void emitLink(String value) {
      ServicesBinding.instance.channelBuffers.push(
        links.name,
        const StandardMethodCodec().encodeSuccessEnvelope(value),
        (_) {},
      );
    }

    setUp(() {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      requests.clear();
      authorizations.clear();
      listening = Completer<void>();
      linkCancels = 0;
      tracks = _MemoryTracks();
      viewer = (_) async => account();
      authenticate = (uri) async => callback(uri);
      container = ProviderContainer(
        overrides: [
          tracksProvider(syncId: 1).overrideWith(() => tracks),
          provider.overrideWith(
            () => Anilist(
              client: MockClient((request) async {
                requests.add(request);
                expect(request.url.toString(), 'https://graphql.anilist.co/');
                expect(request.headers['Authorization'], 'Bearer test-access');
                return viewer(request);
              }),
            ),
          ),
        ],
      );
      // Keep the in-memory account owner alive like the account screen.
      container.listen(tracksProvider(syncId: 1), (_, _) {});
      tracker = container.read(provider.notifier);
      messenger.setMockMethodCallHandler(browser, (call) async {
        if (call.method != 'authenticate') return null;
        expect(call.arguments['callbackUrlScheme'], 'nodelane-comics');
        recordAuthorization(call.arguments['url'] as String);
        return authenticate(authorizations.last);
      });
      messenger.setMockMethodCallHandler(links, (call) async {
        if (call.method == 'listen' && !listening.isCompleted) {
          listening.complete();
        }
        if (call.method == 'cancel') linkCancels++;
        return null;
      });
      messenger.setMockMethodCallHandler(launcher, (call) async {
        if (call.method != 'launch') return true;
        recordAuthorization(call.arguments['url'] as String);
        await listening.future;
        emitLink('nodelane-comics://nodelane-auth#unrelated');
        emitLink(await authenticate(authorizations.last));
        return true;
      });
    });

    tearDown(() async {
      container.dispose();
      await Future<void>.delayed(Duration.zero);
      for (final channel in [browser, launcher, links]) {
        messenger.setMockMethodCallHandler(channel, null);
      }
      debugDefaultTargetPlatformOverride = null;
    });

    test('shares sign-in, verifies the viewer and saves only the NodeLane identity', () async {
      final first = tracker.login();
      expect(tracker.login(), same(first));
      expect(await first, isTrue);
      expect(authorizations, hasLength(1));
      expect(requests, hasLength(1));
      expect(tracks.saved, hasLength(1));
      final saved = tracks.saved.single;
      final oauth = OAuth.fromJson(jsonDecode(saved.oAuth!));
      expect(oauth.clientId, '55972');
      expect(oauth.accessToken, 'test-access');
      expect(oauth.refreshToken, isNull);
      expect(
        oauth.expiresIn!,
        greaterThan(DateTime.now().millisecondsSinceEpoch),
      );
      expect(saved.username, '123');
      expect(saved.displayName, 'Reader');
      expect(saved.avatarUrl, 'https://example.test/avatar.png');
      expect(jsonDecode(saved.prefs!)['scoreFormat'], 'POINT_10');
      expect(await tracker.checkRefresh(), isTrue);
    });

    test('rejects upstream, wrong-state and duplicate-token callbacks before any API request', () async {
      for (final mutate in <Uri Function(Uri)>[
        (uri) => uri.replace(scheme: 'mangayomi'),
        (uri) => uri.replace(fragment: '${uri.fragment}&state=wrong'),
        (uri) => uri.replace(fragment: '${uri.fragment}&access_token=other'),
      ]) {
        authenticate = (uri) async =>
            mutate(Uri.parse(callback(uri))).toString();
        expect(await tracker.login(), isFalse);
      }
      expect(requests, isEmpty);
      expect(tracks.saved, isEmpty);
    });

    test('cancellation and failed viewer verification allow a fresh successful login', () async {
      authenticate = (_) async => throw PlatformException(code: 'CANCELED');
      expect(await tracker.login(), isFalse);
      expect(requests, isEmpty);
      authenticate = (uri) async => callback(uri);
      viewer = (_) async => http.Response('unavailable', 503);
      expect(await tracker.login(), isFalse);
      expect(tracks.saved, isEmpty);
      viewer = (_) async => account();
      expect(await tracker.login(), isTrue);
      expect(
        authorizations.map((uri) => uri.queryParameters['state']).toSet(),
        hasLength(3),
      );
      expect(tracks.saved, hasLength(1));
    });

    testWidgets('rejects missing, foreign and expired client credentials', (
      tester,
    ) async {
      debugDefaultTargetPlatformOverride = null;
      await tester.pumpWidget(
        MaterialApp(
          builder: BotToastInit(),
          navigatorObservers: [BotToastNavigatorObserver()],
          home: const Scaffold(),
        ),
      );
      for (final clientId in <String?>[null, 'upstream-client', '55972']) {
        tracks.seed(
          TrackPreference(
            syncId: 1,
            oAuth: jsonEncode(
              OAuth(
                accessToken: 'old-access',
                expiresIn: clientId == '55972'
                    ? 0
                    : DateTime.now()
                          .add(const Duration(days: 1))
                          .millisecondsSinceEpoch,
                clientId: clientId,
              ).toJson(),
            ),
          ),
        );
        expect(await container.read(provider.notifier).checkRefresh(), isFalse);
        await tester.pump();
      }
      expect(tracks.logouts, 3);
      expect(requests, isEmpty);
      BotToast.cleanAll();
      await tester.pumpAndSettle();
    });

    test(
      'desktop custom links keep the fragment and release their listener',
      () async {
        debugDefaultTargetPlatformOverride = TargetPlatform.windows;
        expect(await tracker.login(), isTrue);
        await Future<void>.delayed(Duration.zero);
        expect(tracks.saved, hasLength(1));
        expect(linkCancels, 1);
      },
    );

    test(
      'disposing during verification discards the late account result',
      () async {
        final requested = Completer<void>();
        final pending = Completer<http.Response>();
        viewer = (_) {
          requested.complete();
          return pending.future;
        };
        final signingIn = tracker.login();
        await requested.future;
        container.dispose();
        pending.complete(account());
        expect(await signingIn, isFalse);
        expect(tracks.saved, isEmpty);
      },
    );
  });
  group('MyAnimeList login', () {
    const iosId = '79c9fc22f3d141372e12b62e48ffddfd';
    const androidId = '8205c12a0bef7f51110aa5ba5bcc8533';
    const desktopId = 'd3e6963529b9fe709b42e6dc3eb24856';
    const platforms = {
      TargetPlatform.iOS: iosId,
      TargetPlatform.android: androidId,
      TargetPlatform.macOS: desktopId,
      TargetPlatform.windows: desktopId,
      TargetPlatform.linux: desktopId,
    };
    const redirect = 'nodelane-comics://myanimelist-auth';
    const browser = MethodChannel('flutter_web_auth_2');
    const launcher = MethodChannel('plugins.flutter.io/url_launcher');
    const links = MethodChannel('com.llfbandit.app_links/events');
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    late ProviderContainer container;
    late MyAnimeListProvider provider;
    late _MemoryTracks tracks;
    late Future<String> Function(Uri) authenticate;
    late Future<http.Response> Function(http.Request) respond;
    final authorizations = <Uri>[];
    final requests = <http.Request>[];
    late Completer<void> listening;
    var linkCancels = 0;
    var opensBrowser = true;

    void emitLink(String value) => ServicesBinding.instance.channelBuffers.push(
      links.name,
      const StandardMethodCodec().encodeSuccessEnvelope(value),
      (_) {},
    );

    Future<String> authorize(String url) {
      final uri = Uri.parse(url);
      expect(uri.origin, 'https://myanimelist.net');
      expect(uri.path, '/v1/oauth2/authorize');
      expect(uri.queryParameters['redirect_uri'], redirect);
      expect(uri.queryParameters['response_type'], 'code');
      expect(uri.queryParameters['code_challenge_method'], 'plain');
      expect(
        uri.queryParameters['code_challenge'],
        matches(RegExp(r'^[A-Za-z0-9_-]{43,128}$')),
      );
      expect(
        uri.queryParameters['state'],
        isNot(uri.queryParameters['code_challenge']),
      );
      authorizations.add(uri);
      return authenticate(uri);
    }

    String callback(Uri uri) => Uri.parse(redirect)
        .replace(
          queryParameters: {
            'code': 'test-code',
            'state': uri.queryParameters['state']!,
          },
        )
        .toString();

    http.Response token() => http.Response(
      jsonEncode({
        'token_type': 'Bearer',
        'access_token': 'test-access',
        'refresh_token': 'test-refresh',
        'expires_in': 3600,
      }),
      200,
    );

    Future<http.Response> success(http.Request request) async {
      if (request.url.path.endsWith('/token')) return token();
      expect(
        request.url.toString(),
        'https://api.myanimelist.net/v2/users/@me',
      );
      expect(request.headers['Authorization'], 'Bearer test-access');
      return http.Response(
        jsonEncode({
          'name': 'Reader',
          'picture': 'https://example.test/mal.png',
        }),
        200,
      );
    }

    void seed(String? clientId, {bool expired = false}) => tracks.seed(
      TrackPreference(
        syncId: 1,
        username: 'Reader',
        oAuth: jsonEncode(
          OAuth(
            clientId: clientId,
            accessToken: 'old-access',
            refreshToken: 'old-refresh',
            expiresIn: expired
                ? 0
                : DateTime.now()
                      .add(const Duration(hours: 1))
                      .millisecondsSinceEpoch,
          ).toJson(),
        ),
      ),
    );

    setUp(() {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      authorizations.clear();
      requests.clear();
      tracks = _MemoryTracks();
      authenticate = (uri) async => callback(uri);
      respond = success;
      listening = Completer<void>();
      linkCancels = 0;
      opensBrowser = true;
      container = ProviderContainer(
        overrides: [
          tracksProvider(syncId: 1).overrideWith(() => tracks),
          myAnimeListProvider.overrideWith(
            () => MyAnimeList(
              client: MockClient((request) async {
                requests.add(request);
                if (request.url.path.endsWith('/token')) {
                  expect(
                    request.url.toString(),
                    'https://myanimelist.net/v1/oauth2/token',
                  );
                  expect(request.bodyFields, isNot(contains('client_secret')));
                  if (request.bodyFields['grant_type'] ==
                      'authorization_code') {
                    final auth = authorizations.last.queryParameters;
                    expect(request.bodyFields['client_id'], auth['client_id']);
                    expect(request.bodyFields['redirect_uri'], redirect);
                    expect(
                      request.bodyFields['code_verifier'],
                      auth['code_challenge'],
                    );
                    expect(request.bodyFields['code'], 'test-code');
                  }
                }
                return respond(request);
              }),
            ),
          ),
        ],
      );
      provider = myAnimeListProvider(
        syncId: 1,
        itemType: null,
        widgetRef: container,
      );
      container.listen(tracksProvider(syncId: 1), (_, _) {});
      messenger.setMockMethodCallHandler(browser, (call) async {
        if (call.method != 'authenticate') return null;
        expect(call.arguments['callbackUrlScheme'], 'nodelane-comics');
        return authorize(call.arguments['url'] as String);
      });
      messenger.setMockMethodCallHandler(links, (call) async {
        if (call.method == 'listen') listening.complete();
        if (call.method == 'cancel') {
          linkCancels++;
          listening = Completer<void>();
        }
        return null;
      });
      messenger.setMockMethodCallHandler(launcher, (call) async {
        if (call.method != 'launch') return true;
        await listening.future;
        if (!opensBrowser) return false;
        emitLink('nodelane-comics://anilist-auth#unrelated');
        emitLink(await authorize(call.arguments['url'] as String));
        return true;
      });
    });

    tearDown(() async {
      container.dispose();
      await Future<void>.delayed(Duration.zero);
      for (final channel in [browser, launcher, links]) {
        messenger.setMockMethodCallHandler(channel, null);
      }
      debugDefaultTargetPlatformOverride = null;
    });

    test('uses each platform identity with matching PKCE and saves a verified account once', () async {
      for (final platform in platforms.entries) {
        debugDefaultTargetPlatformOverride = platform.key;
        final tracker = container.read(provider.notifier);
        final pending = tracker.login();
        expect(tracker.login(), same(pending));
        expect(await pending, isTrue);
        expect(
          authorizations.last.queryParameters['client_id'],
          platform.value,
        );
        final saved = tracks.saved.last;
        expect(
          OAuth.fromJson(jsonDecode(saved.oAuth!)).clientId,
          platform.value,
        );
        expect(saved.username, 'Reader');
        expect(saved.displayName, 'Reader');
        expect(saved.avatarUrl, endsWith('/mal.png'));
        expect(await tracker.checkRefresh(), isTrue);
      }
      expect(tracks.saved, hasLength(platforms.length));
      expect(requests, hasLength(platforms.length * 2));
      expect(linkCancels, 2);
      expect(
        authorizations.map((uri) => uri.queryParameters['state']).toSet(),
        hasLength(platforms.length),
      );
      expect(
        authorizations
            .map((uri) => uri.queryParameters['code_challenge'])
            .toSet(),
        hasLength(platforms.length),
      );
    });

    test('rejects foreign redirects, wrong state and duplicate codes before exchange', () async {
      for (final mutate in <Uri Function(Uri)>[
        (uri) => uri.replace(scheme: 'mangayomi'),
        (uri) => uri.replace(host: 'anilist-auth'),
        (uri) => uri.replace(
          queryParameters: {...uri.queryParameters, 'state': 'wrong'},
        ),
        (uri) => uri.replace(query: '${uri.query}&code=other'),
        (uri) => uri.replace(
          queryParameters: {...uri.queryParameters, 'error': 'access_denied'},
        ),
      ]) {
        authenticate = (uri) async =>
            mutate(Uri.parse(callback(uri))).toString();
        expect(await container.read(provider.notifier).login(), isFalse);
      }
      expect(requests, isEmpty);
      expect(tracks.saved, isEmpty);
    });

    test('cancellation and invalid token or account responses can retry without saving', () async {
      authenticate = (_) async => throw PlatformException(code: 'CANCELED');
      expect(await container.read(provider.notifier).login(), isFalse);
      authenticate = (uri) async => callback(uri);
      for (final failure in <Future<http.Response> Function(http.Request)>[
        (_) async => http.Response('denied', 400),
        (_) async => http.Response('{"access_token":"incomplete"}', 200),
        (request) async => request.url.path.endsWith('/token')
            ? token()
            : http.Response('unavailable', 503),
      ]) {
        respond = failure;
        expect(await container.read(provider.notifier).login(), isFalse);
        expect(tracks.saved, isEmpty);
      }
      respond = success;
      expect(await container.read(provider.notifier).login(), isTrue);
      expect(tracks.saved, hasLength(1));
      expect(
        authorizations.map((uri) => uri.queryParameters['state']).toSet(),
        hasLength(5),
      );
    });

    test(
      'rejects old and other-platform sessions even before they expire',
      () async {
        for (final platform in platforms.entries) {
          debugDefaultTargetPlatformOverride = platform.key;
          for (final clientId in [
            null,
            'upstream-client',
            iosId,
            androidId,
            desktopId,
          ].where((id) => id != platform.value)) {
            seed(clientId);
            expect(
              await container.read(provider.notifier).checkRefresh(),
              isFalse,
            );
          }
        }
        expect(tracks.logouts, platforms.length * 4);
        expect(requests, isEmpty);
      },
    );

    test('restores and refreshes with the issuing platform identity', () async {
      for (final platform in {
        TargetPlatform.iOS: iosId,
        TargetPlatform.android: androidId,
        TargetPlatform.macOS: desktopId,
      }.entries) {
        debugDefaultTargetPlatformOverride = platform.key;
        seed(platform.value, expired: true);
        expect(await container.read(provider.notifier).checkRefresh(), isTrue);
        expect(
          OAuth.fromJson(jsonDecode(tracks.saved.last.oAuth!)).clientId,
          platform.value,
        );
        final request = requests[requests.length - 2];
        expect(request.bodyFields, {
          'client_id': platform.value,
          'grant_type': 'refresh_token',
          'refresh_token': 'old-refresh',
        });
      }
      expect(requests, hasLength(6));
      expect(authorizations, isEmpty);
    });

    testWidgets(
      'a refused refresh makes one request and never switches client identity',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            builder: BotToastInit(),
            navigatorObservers: [BotToastNavigatorObserver()],
            home: const Scaffold(),
          ),
        );
        seed(iosId, expired: true);
        respond = (_) async => http.Response('denied', 400);
        expect(await container.read(provider.notifier).checkRefresh(), isFalse);
        expect(requests, hasLength(1));
        expect(requests.single.bodyFields['client_id'], iosId);
        expect(tracks.logouts, 1);
        expect(tracks.saved, isEmpty);
        await tester.pump();
        BotToast.cleanAll();
        await tester.pumpAndSettle();
        debugDefaultTargetPlatformOverride = null;
      },
    );

    test('disposal discards a late verified account', () async {
      final requested = Completer<void>();
      final pending = Completer<http.Response>();
      respond = (request) async {
        if (request.url.path.endsWith('/token')) return token();
        requested.complete();
        return pending.future;
      };
      final signingIn = container.read(provider.notifier).login();
      await requested.future;
      container.dispose();
      pending.complete(http.Response('{"name":"Reader"}', 200));
      expect(await signingIn, isFalse);
      expect(tracks.saved, isEmpty);
    });

    test('desktop launch failure and disposal release the callback and allow retry', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.windows;
      opensBrowser = false;
      expect(await container.read(provider.notifier).login(), isFalse);
      expect(linkCancels, 1);
      expect(requests, isEmpty);
      opensBrowser = true;
      expect(await container.read(provider.notifier).login(), isTrue);
      expect(linkCancels, 2);
      expect(tracks.saved, hasLength(1));

      final launched = Completer<void>();
      messenger.setMockMethodCallHandler(launcher, (call) async {
        if (call.method == 'launch') launched.complete();
        return true;
      });
      final pending = container.read(provider.notifier).login();
      await launched.future;
      container.dispose();
      expect(await pending, isFalse);
      expect(linkCancels, 3);
      expect(tracks.saved, hasLength(1));
      expect(requests, hasLength(2));
    });

    test(
      'desktop timeout releases the callback without saving credentials',
      () async {
        debugDefaultTargetPlatformOverride = TargetPlatform.linux;
        messenger.setMockMethodCallHandler(launcher, (call) async {
          return true;
        });
        var timeoutScheduled = false;
        // Keep platform-channel streams on the real event loop; advance only
        // the browser's timeout rather than Flutter's widget clock.
        final result = await runZoned(
          () => container.read(provider.notifier).login(),
          zoneSpecification: ZoneSpecification(
            createTimer: (self, parent, zone, duration, callback) {
              if (duration == const Duration(minutes: 10)) {
                timeoutScheduled = true;
                duration = Duration.zero;
              }
              return parent.createTimer(zone, duration, callback);
            },
          ),
        );
        expect(result, isFalse);
        expect(timeoutScheduled, isTrue);
        expect(linkCancels, 1);
        expect(tracks.saved, isEmpty);
        expect(requests, isEmpty);
      },
      timeout: const Timeout(Duration(seconds: 15)),
    );
  });
}

class _MemoryTracks extends Tracks {
  final saved = <TrackPreference>[];
  int logouts = 0;

  @override
  TrackPreference? build({required int? syncId}) => null;

  void seed(TrackPreference value) => state = value;

  @override
  void login(TrackPreference value) {
    saved.add(value);
    state = value;
  }

  @override
  void logout() {
    logouts++;
    state = null;
  }

  @override
  void setRefreshing(bool refreshing) => state?.refreshing = refreshing;
}

const _simklClientId =
    'c2c74e7a95db1444f40967d2a7757cf3a7aeac83ae581f40de7410a219a03b63';

Map<String, dynamic> _simklToken({
  String access = 'test-access',
  String refresh = 'test-refresh',
}) => {
  'token_type': 'Bearer',
  'expires_in': 604800,
  'access_token': access,
  'refresh_token': refresh,
  'scope': 'media:read media:write',
};

TrackPreference _simklPreference({
  bool expired = false,
  String refresh = 'test-refresh',
}) => TrackPreference(
  syncId: 4,
  username: '4242',
  displayName: 'Someone',
  oAuth: jsonEncode(
    _simklToken(refresh: refresh)
      ..['client_id'] = _simklClientId
      ..['expires_in'] = DateTime.now()
          .add(Duration(days: expired ? -1 : 7))
          .millisecondsSinceEpoch,
  ),
);

class _SimklRepository extends TrackRepository {
  TrackPreference? preference;
  final _queue = DbWriteQueue();

  @override
  TrackPreference? getPreferenceById(int id) => preference;

  @override
  Future<T> writeTransaction<T>(T Function() body) => _queue.run(body);

  @override
  void putAllPreferencesSync(List<TrackPreference> values) =>
      preference = values.single;

  @override
  void deletePreferenceSync(int syncId) => preference = null;
}
