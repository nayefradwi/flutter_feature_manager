class FeatureManagerConfig {
  final Duration? loadTimeout;
  final Duration? cacheExpiry;
  final bool isOverrideEnabled;
  final bool isCacheEnabled;

  FeatureManagerConfig({
    this.loadTimeout,
    this.cacheExpiry,
    this.isOverrideEnabled = true,
    this.isCacheEnabled = true,
  });
}
