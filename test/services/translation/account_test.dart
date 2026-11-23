import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/services/translation/channels/nodelane/account.dart';
import 'package:mangayomi/services/translation/channels/nodelane/session.dart';
import 'package:mangayomi/services/translation/contracts.dart';
import 'package:mangayomi/services/translation/translation_service.dart';
import 'package:url_launcher_platform_interface/link.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

Map<String, dynamic> me({String id = 'user-a'}) => {
  'user': {'id': id, 'name': 'Reader'},
  'entitlements': {
    'plan': 'plus',
    'plan_name': 'PLUS',
    'generated_at': '2026-11-03T08:00:00Z',
    'plus_expires_at': '2026-12-03T08:00:00Z',
    'free_quota': {'available': 24, 'used': 6, 'reserved': 0, 'granted': 30},
    'subscription_quota': {
      'available': 820,
      'used': 172,
      'reserved': 8,
      'granted': 1000,
    },
    'purchase_quota': {
      'available': 150,
      'used': 50,
      'reserved': 0,
      'granted': 200,
    },
  },
};

void main() {
  test('missing quota stays unknown; available excludes reservations and no totals are combined', () {
    final account = NodeLaneAccount.fromJson(
      me(),
      billing: {
        'subscription': {
          'auto_renew': true,
          'next_billed_at': '2026-12-03T08:00:00Z',
        },
      },
    );
    expect(account.subscription!.available, 820);
    expect(account.subscription!.reserved, 8);
    expect(account.purchase!.available, 150);
    expect(account.renewal, NodeLaneRenewal.automatic);
    expect(account.nextBillingAt, DateTime.utc(2026, 12, 3, 8));
    final oldResponse = NodeLaneAccount.fromJson({
      'user': {'id': 'user-a'},
    });
    expect(oldResponse.plan, isNull);
    expect(oldResponse.isFree, isFalse);
    expect(oldResponse.free, isNull);
    expect(NodeLaneQuota.parse({'available': 0}), isNull);
    expect(
      NodeLaneQuota.parse({
        'available': -1,
        'used': 0,
        'reserved': 0,
        'granted': 0,
      }),
      isNull,
    );
  });

  test(
    'unlimited, prepaid and canceled renewal retain their distinct meanings',
    () {
      final data = me();
      data['entitlements']['subscription_quota'] = <String, dynamic>{
        ...data['entitlements']['subscription_quota'],
        'unlimited': true,
      };
      final unlimited = NodeLaneAccount.fromJson(
        data,
        billing: {'prepaid_membership': {}},
      );
      expect(unlimited.subscription!.unlimited, isTrue);
      expect(unlimited.renewal, NodeLaneRenewal.manual);
      final canceled = NodeLaneAccount.fromJson(
        me(),
        billing: {
          'subscription': {'auto_renew': false},
        },
      );
      expect(canceled.renewal, NodeLaneRenewal.stopped);
      final partial = NodeLaneAccount.fromJson(me(), billingUnavailable: true);
      expect(partial.renewal, NodeLaneRenewal.unknown);
      expect(partial.billingUnavailable, isTrue);
      expect(partial.free!.available, 24);
    },
  );

  test('refresh is coalesced, failure keeps the last snapshot, and retry only reads', () async {
    final session = _Session();
    final service = _Service(session);
    addTearDown(service.dispose);
    final first = service.refreshAccount();
    final duplicate = service.refreshAccount();
    expect(identical(first, duplicate), isTrue);
    await Future<void>.delayed(Duration.zero);
    expect(session.reads, 1);
    session.pending.complete(NodeLaneAccount.fromJson(me()));
    await first;
    final snapshot = service.account;
    expect(service.runtime, isNull);
    session.pending = Completer<NodeLaneAccount>();
    final failed = service.refreshAccount();
    await Future<void>.delayed(Duration.zero);
    session.pending.completeError(const TranslationFailure('NETWORK'));
    await failed;
    expect(service.account, same(snapshot));
    expect(service.accountLoadFailed, isTrue);
    expect(service.accountAuthRequired, isFalse);
    session.pending = Completer<NodeLaneAccount>();
    final auth = service.refreshAccount();
    await Future<void>.delayed(Duration.zero);
    session.pending.completeError(const TranslationFailure('AUTH_REQUIRED'));
    await auth;
    expect(service.accountAuthRequired, isTrue);
    expect(service.account, same(snapshot));
  });

  test('billing opens once, drops stale links, and a failed external launch can be retried', () async {
    final session = _Session(),
        service = _Service(session),
        runtime = _Runtime();
    service.runtime = runtime;
    addTearDown(service.dispose);
    final previous = UrlLauncherPlatform.instance, launcher = _Launcher();
    UrlLauncherPlatform.instance = launcher;
    addTearDown(() => UrlLauncherPlatform.instance = previous);
    final url = Uri.https('billing.example', '/pricing/');
    var current = true;
    Future<bool> open() => service.openBillingUpgrade(runtime, () => current);
    final first = open();
    expect(await open(), isFalse);
    current = false;
    session.link.complete(url);
    expect(await first, isFalse);
    expect(launcher.opens, 0);
    current = true;
    session.link = Completer<Uri>();
    final stale = open();
    service.runtime = _Runtime();
    session.link.complete(url);
    expect(await stale, isFalse);
    expect(launcher.opens, 0);
    service.runtime = runtime;
    await expectLater(
      open(),
      throwsA(
        isA<TranslationFailure>().having(
          (e) => e.code,
          'code',
          'BILLING_UNAVAILABLE',
        ),
      ),
    );
    launcher.available = true;
    expect(await open(), isTrue);
    expect(launcher.opens, 2);
  });

  test(
    'logout and disposal cancel reads and reject late account data',
    () async {
      final session = _Session();
      final service = _Service(session);
      final pending = service.refreshAccount();
      await Future<void>.delayed(Duration.zero);
      await service.logout();
      expect(session.cancellation!.isCancelled, isTrue);
      session.pending.complete(NodeLaneAccount.fromJson(me()));
      await pending;
      expect(service.account, isNull);
      expect(service.loggedIn, isFalse);
      expect(service.accountLoading, isFalse);
      session.id = 'user-b';
      session.pending = Completer<NodeLaneAccount>();
      final next = service.refreshAccount();
      await Future<void>.delayed(Duration.zero);
      service.dispose();
      expect(session.cancellation!.isCancelled, isTrue);
      session.pending.complete(NodeLaneAccount.fromJson(me(id: 'user-b')));
      await next;
      expect(service.account, isNull);
    },
  );
}

class _Session extends NodeLaneSession {
  _Session() : super(Uri.https('example.invalid'));
  String? id = 'user-a';
  int reads = 0;
  var pending = Completer<NodeLaneAccount>();
  var link = Completer<Uri>();
  @override
  Future<Uri> billingUpgradeLink(TranslationCancellation cancel) => link.future;
  TranslationCancellation? cancellation;
  @override
  String? get userId => id;
  @override
  Future<NodeLaneAccount> readAccount(TranslationCancellation cancel) {
    reads++;
    cancellation = cancel;
    return pending.future;
  }

  @override
  Future<void> logout() async {
    id = null;
  }
}

class _Service extends TranslationService {
  _Service(NodeLaneSession session) : super(session: session);
  @override
  Future<void> initialize() async {}
}

class _Runtime extends Fake implements ChannelRuntime {
  @override
  Future<void> dispose() async {}
}

class _Launcher extends UrlLauncherPlatform {
  bool available = false;
  int opens = 0;
  @override
  LinkDelegate? get linkDelegate => null;
  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    expect(options.mode, PreferredLaunchMode.externalApplication);
    opens++;
    return available;
  }
}
