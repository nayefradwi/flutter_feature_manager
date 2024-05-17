class FeatureManagerConfig {
  final Duration? loadTimeout;
  final Duration? cacheExpiry;
  final bool isOverrideEnabled;
  final bool isCacheEnabled;

  const FeatureManagerConfig({
    this.loadTimeout = const Duration(seconds: 10),
    this.cacheExpiry = const Duration(days: 1),
    this.isOverrideEnabled = true,
    this.isCacheEnabled = true,
  });
}
