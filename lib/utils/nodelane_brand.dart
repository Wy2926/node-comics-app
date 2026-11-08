/// Product identity and destinations, independent of storage and protocols.
abstract final class NodeLaneBrand {
  static const displayName = 'NodeLane Comics';
  // Stable app-owned request identity; browser and source-specific UAs are
  // managed separately. No duplicated release version to keep in sync.
  static const userAgent = 'nodelane-comics';
  static const repository = 'Wy2926/node-comics-app';
  static const repositoryUrl = 'https://github.com/$repository';
  static const updateManifestUrl = String.fromEnvironment(
    'NODELANE_UPDATE_MANIFEST_URL',
    defaultValue: 'https://comics-updates.nodelane.net/stable/index.json',
  );
  static const appMark = 'assets/brand/app-mark.png';
  static const accountMark = 'assets/brand/account-mark.png';
}
