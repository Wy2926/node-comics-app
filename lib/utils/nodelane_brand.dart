/// Product destinations only. Upstream attribution and storage identities stay
/// independent of the app's display name and release repository.
abstract final class NodeLaneBrand {
  static const repository = 'Wy2926/node-comics-app';
  static const repositoryUrl = 'https://github.com/$repository';
  static const releasesApi =
      'https://api.github.com/repos/$repository/releases/latest';
  static const appMark = 'assets/brand/app-mark.png';
  static const accountMark = 'assets/brand/account-mark.png';
}
