import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/repositories/translation_repository.dart';
import 'package:path_provider/path_provider.dart';

import '../nodelane_provider.dart';
import 'translation_coordinator.dart';

final translationProvider = ChangeNotifierProvider<TranslationCoordinator>((
  ref,
) {
  final coordinator = TranslationCoordinator(
    auth: ref.watch(nodeLaneAuthProvider),
    repository: _repository(),
  );
  final lifecycle = AppLifecycleListener(
    onStateChange: (state) =>
        coordinator.setForeground(state == AppLifecycleState.resumed),
  );
  ref.onDispose(lifecycle.dispose);
  return coordinator;
});
Future<TranslationRepository> _repository() async {
  final root = await getApplicationSupportDirectory();
  final directory = await Directory('${root.path}/nodelane_translation')
      .create(recursive: true);
  if (Platform.isIOS) {
    await const MethodChannel('net.nodelane.comics/private_storage')
        .invokeMethod<void>('excludeFromBackup', {'path': directory.path});
  }
  return TranslationRepository(isar, directory);
}
