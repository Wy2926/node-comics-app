import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract interface class NodeLaneCredentialStore {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
}

/// Separate from source-site cookies, tracker accounts and backup contents.
/// There is no plaintext fallback for NodeLane credentials.
class SecureNodeLaneCredentialStore implements NodeLaneCredentialStore {
  const SecureNodeLaneCredentialStore();

  static const _storage = FlutterSecureStorage(
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.passcode,
      synchronizable: false,
    ),
  );

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);
}
