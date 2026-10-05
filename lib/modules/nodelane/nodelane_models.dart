import 'dart:convert';

import 'package:crypto/crypto.dart';

class NodeLaneUser {
  const NodeLaneUser({
    required this.id,
    required this.name,
    required this.role,
  });

  factory NodeLaneUser.fromJson(Map<String, dynamic> json) => NodeLaneUser(
    id: _requiredString(json, 'id'),
    name: _requiredString(json, 'name'),
    role: _requiredString(json, 'role'),
  );

  final String id;
  final String name;
  final String role;

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'role': role};
}

class NodeLaneModeEntitlement {
  NodeLaneModeEntitlement.fromJson(Map<String, dynamic> json)
    : allowed = json['allowed'] == true,
      unlimited = json['unlimited'] == true,
      quotaKind = json['quota_kind'] as String? ?? '',
      available = (json['quota'] as Map?)?['available'] as int?,
      used = (json['quota'] as Map?)?['used'] as int?,
      reserved = (json['quota'] as Map?)?['reserved'] as int?,
      granted = (json['quota'] as Map?)?['granted'] as int?,
      resetsAt = DateTime.tryParse(
        (json['quota'] as Map?)?['resets_at'] as String? ?? '',
      );

  final bool allowed;
  final bool unlimited;
  final String quotaKind;
  final int? available;
  final int? used;
  final int? reserved;
  final int? granted;
  final DateTime? resetsAt;
}

class NodeLaneEntitlements {
  NodeLaneEntitlements.fromJson(Map<String, dynamic> json)
    : plan = _requiredString(json, 'plan'),
      plusExpiresAt = DateTime.tryParse(
        json['plus_expires_at'] as String? ?? '',
      ),
      generatedAt = DateTime.tryParse(json['generated_at'] as String? ?? ''),
      modes = Map.unmodifiable(
        (json['modes'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(
            key,
            NodeLaneModeEntitlement.fromJson(value as Map<String, dynamic>),
          ),
        ),
      ),
      _json = Map.unmodifiable(json);

  final String plan;
  final DateTime? plusExpiresAt;
  final DateTime? generatedAt;
  final Map<String, NodeLaneModeEntitlement> modes;
  final Map<String, dynamic> _json;

  Map<String, dynamic> toJson() => Map.of(_json);
}

/// Contains API-verified display data only, never credentials.
class NodeLaneAccount {
  const NodeLaneAccount({
    required this.user,
    required this.entitlements,
    required this.serviceOrigin,
    required this.issuer,
    required this.subject,
    required this.sessionId,
  });

  final NodeLaneUser user;
  final NodeLaneEntitlements entitlements;
  final String serviceOrigin;
  final String issuer;
  final String subject;
  final String sessionId;

  String get scopeKey => sha256
      .convert(utf8.encode(jsonEncode([serviceOrigin, issuer, subject])))
      .toString();
}

class NodeLaneAuthState {
  const NodeLaneAuthState({
    this.initialized = false,
    this.busy = false,
    this.account,
    this.error,
  });

  final bool initialized;
  final bool busy;
  final NodeLaneAccount? account;
  final NodeLaneException? error;
}

/// Only fixed, safe user messages may be stored here. Raw provider responses,
/// callback URLs and transport exceptions must not escape through this type.
class NodeLaneException implements Exception {
  const NodeLaneException(
    this.code,
    this.message, {
    this.statusCode,
    this.retryAfterSeconds,
  });

  final String code;
  final String message;
  final int? statusCode;
  final int? retryAfterSeconds;

  @override
  String toString() => 'NodeLaneException($code): $message';
}

String _requiredString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! String || value.isEmpty) {
    throw const FormatException('Incomplete NodeLane response.');
  }
  return value;
}
