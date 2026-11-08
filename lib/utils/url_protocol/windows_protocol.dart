import 'dart:io';

import 'package:win32_registry/win32_registry.dart';

import 'protocol.dart';

/// Registers this installed executable as the NodeLane URL handler on Windows.
void registerAppUrlProtocol() {
  final rootKey = CURRENT_USER.create('SOFTWARE\\Classes\\$appUrlScheme');
  try {
    rootKey.setValue('', RegistryValue.string('URL:$appUrlScheme'));
    rootKey.setValue('URL Protocol', RegistryValue.string(''));
    final commandKey = rootKey.create(r'shell\open\command');
    try {
      commandKey.setValue(
        '',
        RegistryValue.string('"${Platform.resolvedExecutable}" "%1"'),
      );
    } finally {
      commandKey.close();
    }
  } finally {
    rootKey.close();
  }
}
