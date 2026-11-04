const nodeLaneRepositoryId = 'net.nodelane.extensions';

const nodeLaneCatalogUrl = String.fromEnvironment(
  'NODELANE_CATALOG_URL',
  defaultValue: 'http://127.0.0.1:8787/index.json',
);

const nodeLaneHostCapabilities = <String>{'image.tile-shuffle.v1'};
