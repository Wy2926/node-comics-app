const nodeLaneRepositoryId = 'net.nodelane.extensions';

const nodeLaneCatalogUrl = String.fromEnvironment(
  'NODELANE_CATALOG_URL',
  defaultValue: 'https://comics-extensions.nodelane.net/stable/index.json',
);

const nodeLaneHostCapabilities = <String>{'image.tile-shuffle.v1'};
