/// Catalog scenario -> engine row, a port of the website's
/// server/services/financial-model/scenario-row-map.ts (engineScenarioId). The server
/// attaches `engineRow` to corporate scenarios, but GET /self-paced/progress/scenarios
/// drops it, so the self-paced panel resolves it here from the same pure rule.
///
/// The full nine-scenario catalog (the live one) is listed in engine-row order and maps
/// positionally; the table only describes the three-scenario development catalog.
const Map<String, Map<int, Map<int, int>>> _devCatalogMap = {
  'financing': {
    1: {1: 1, 2: 5, 3: 2},
    2: {1: 3, 2: 5, 3: 4},
    3: {1: 1, 2: 2, 3: 6},
  },
  'investing': {
    1: {1: 1, 2: 8, 3: 4},
    2: {1: 2, 2: 8, 3: 9},
    3: {1: 3, 2: 5, 3: 8},
  },
  'operating': {
    1: {1: 1, 2: 3, 3: 5},
    2: {1: 9, 2: 6, 3: 4},
    3: {1: 7, 2: 9, 3: 4},
  },
};

int engineRowFor(String module, int round, int catalogId, int? catalogSize) {
  if (catalogSize != null && catalogSize > 3) return catalogId;
  return _devCatalogMap[module]?[round]?[catalogId] ?? catalogId;
}
