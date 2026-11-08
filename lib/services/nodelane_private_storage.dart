import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';

const nodeLanePrivateVault = FlutterSecureStorage(
  aOptions: AndroidOptions(storageNamespace: 'nodelane_private'),
  iOptions: IOSOptions(
    accessibility: KeychainAccessibility.first_unlock_this_device,
  ),
);

Future<Directory> nodeLanePrivateDirectory() async {
  if (Platform.isIOS) {
    final path = await const MethodChannel('nodelane/private_storage')
        .invokeMethod<String>('prepare');
    if (path == null) {
      throw const FileSystemException('Private storage unavailable');
    }
    return Directory(path);
  }
  final support = await getApplicationSupportDirectory();
  return Directory('${support.path}/nodelane-translation')
      .create(recursive: true);
}
