const nodeLaneRepositoryId = 'net.nodelane.extensions';

const nodeLaneCatalogUrl = String.fromEnvironment(
  'NODELANE_CATALOG_URL',
  defaultValue: 'https://comics-extensions.nodelane.net/stable/index.json',
);

const nodeLaneHostCapabilities = <String>{
  'image.tile-shuffle.v1',
  'image.tile-transpose.v1',
  'image.strip-reverse.v1',
  'crypto.md5.v1',
  'crypto.aes-ecb.v1',
};
