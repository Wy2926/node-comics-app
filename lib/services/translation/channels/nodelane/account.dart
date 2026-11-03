/// Read-only projections of the official account API. Missing values stay
/// unknown: a partial or older response must never become a zero balance.
class NodeLaneQuota {
  const NodeLaneQuota({
    required this.available,
    required this.used,
    required this.reserved,
    required this.granted,
    this.unlimited = false,
    this.resetsAt,
    this.expiresAt,
  });
  final int available, used, reserved, granted;
  final bool unlimited;
  final DateTime? resetsAt, expiresAt;

  static NodeLaneQuota? parse(dynamic value) {
    if (value is! Map) return null;
    final values = [
      value['available'],
      value['used'],
      value['reserved'],
      value['granted'],
    ];
    if (values.any((v) => v is! int || v < 0)) return null;
    return NodeLaneQuota(
      available: values[0] as int,
      used: values[1] as int,
      reserved: values[2] as int,
      granted: values[3] as int,
      unlimited: value['unlimited'] == true,
      resetsAt: _date(value['resets_at']),
      expiresAt: _date(value['next_expiry_at']),
    );
  }
}

enum NodeLaneRenewal { automatic, manual, stopped, gift, unknown }

class NodeLaneAccount {
  const NodeLaneAccount({
    required this.id,
    required this.name,
    required this.updatedAt,
    this.plan,
    this.planName,
    this.expiresAt,
    this.free,
    this.subscription,
    this.purchase,
    this.renewal = NodeLaneRenewal.unknown,
    this.nextBillingAt,
    this.billingUnavailable = false,
    this.renewalNeedsAttention = false,
  });
  final String id, name;
  final String? plan, planName;
  final DateTime updatedAt;
  final DateTime? expiresAt, nextBillingAt;
  final NodeLaneQuota? free, subscription, purchase;
  final NodeLaneRenewal renewal;
  final bool billingUnavailable, renewalNeedsAttention;
  bool get isFree => plan == 'free';
  bool get hasMembership => plan != null && !isFree;

  factory NodeLaneAccount.fromJson(
    Map<String, dynamic> me, {
    Map<String, dynamic>? billing,
    bool billingUnavailable = false,
  }) {
    final user = me['user'];
    if (user is! Map ||
        user['id'] is! String ||
        (user['id'] as String).isEmpty) {
      throw const FormatException('Invalid account response');
    }
    final entitlements = me['entitlements'] is Map
        ? me['entitlements'] as Map
        : const {};
    final sub = billing?['subscription'];
    var renewal = NodeLaneRenewal.unknown;
    if (sub is Map && sub['auto_renew'] is bool) {
      renewal = sub['auto_renew'] == true
          ? NodeLaneRenewal.automatic
          : NodeLaneRenewal.stopped;
    } else if (billing?['prepaid_membership'] is Map) {
      renewal = NodeLaneRenewal.manual;
    } else if (billing?['gift'] is Map &&
        billing!['gift']['state'] == 'active') {
      renewal = NodeLaneRenewal.gift;
    }
    return NodeLaneAccount(
      id: user['id'] as String,
      name: user['name'] is String ? user['name'] as String : '',
      plan: _text(entitlements['plan']),
      planName: _text(entitlements['plan_name']),
      expiresAt: _date(entitlements['plus_expires_at']),
      updatedAt: _date(entitlements['generated_at']) ?? DateTime.now().toUtc(),
      free: NodeLaneQuota.parse(entitlements['free_quota']),
      subscription: NodeLaneQuota.parse(entitlements['subscription_quota']),
      purchase: NodeLaneQuota.parse(entitlements['purchase_quota']),
      renewal: renewal,
      nextBillingAt: sub is Map ? _date(sub['next_billed_at']) : null,
      billingUnavailable: billingUnavailable,
      renewalNeedsAttention:
          sub is Map &&
          (sub['renewal_state'] == 'attention' ||
              const ['past_due', 'unpaid'].contains(sub['status'])),
    );
  }
}

String? _text(dynamic value) =>
    value is String && value.trim().isNotEmpty ? value : null;
DateTime? _date(dynamic value) =>
    value is String ? DateTime.tryParse(value) : null;
