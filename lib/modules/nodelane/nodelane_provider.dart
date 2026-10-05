import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/nodelane/nodelane_auth_service.dart';
import 'package:mangayomi/modules/nodelane/nodelane_config.dart';

final nodeLaneAuthProvider = Provider<NodeLaneAuthService>((ref) {
  final service = NodeLaneAuthService(config: NodeLaneConfig.fromEnvironment());
  ref.onDispose(service.dispose);
  unawaited(service.initialize());
  return service;
});
