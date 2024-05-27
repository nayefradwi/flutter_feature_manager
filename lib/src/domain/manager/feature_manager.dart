part of 'abstract_feature_manager.dart';

class FeatureManager extends IFeatureManager {
  String _appVersion = '';

  FeatureManager({
    required IRemoteDataSource remoteDataSource,
    required IFeatureDataSource defaultsDataSource,
    super.config = const FeatureManagerConfig(),
    CacheDataSource? cacheDataSource,
    IOverrideDataSource? overrideDataSource,
    super.restartApp,
  }) : super(
          dataSources: [
            if (config.isOverrideEnabled)
              overrideDataSource ?? OverrideDataSource(),
            remoteDataSource,
            if (config.isCacheEnabled) cacheDataSource ?? CacheDataSource(),
            defaultsDataSource,
          ],
        );

  FeatureManager.multipleRemoteSources({
    required IFeatureDataSource defaultsDataSource,
    required List<IRemoteDataSource> remoteDataSources,
    super.config = const FeatureManagerConfig(),
    CacheDataSource? cacheDataSource,
    IOverrideDataSource? overrideDataSource,
    super.restartApp,
  }) : super(
          dataSources: [
            if (config.isOverrideEnabled)
              overrideDataSource ?? OverrideDataSource(),
            ...remoteDataSources,
            if (config.isCacheEnabled) cacheDataSource ?? CacheDataSource(),
            defaultsDataSource,
          ],
        );

  @override
  Feature<T>? tryToGetFeature<T>(String key) {
    try {
      var feature = features[key];
      feature ??= Feature.empty(key);
      if (!feature.isVersionEnabled(appVersion)) {
        return feature.withValue(feature.getDefaultValue());
      }
      final value = feature.parseValue<T>();
      return feature.withValue<T>(value);
    } catch (e, stack) {
      logger.severe('Failed to get feature $e', e, stack);
      return null;
    }
  }

  @override
  Feature<T> getFeature<T>(String key, {required T defaultValue}) {
    final feature = tryToGetFeature<T>(key);
    return feature ?? Feature(key: key, value: defaultValue);
  }

  @override
  Future<void> initialize() async {
    final packageInfo = await PackageInfo.fromPlatform();
    _appVersion = packageInfo.version;
    var remoteFeatures = <String, Feature<dynamic>>{};

    for (var i = dataSources.length - 1; i >= 0; i--) {
      final source = dataSources[i];
      await _initializeSource(source);
      final features = await source.loadFeatures();
      if (source is IRemoteDataSource) {
        remoteFeatures = features;
      }
      for (final entry in features.entries) {
        this.features[entry.key] = entry.value;
      }
    }
    unawaited(_cacheRemoteFeatures(remoteFeatures));
  }

  Future<void> _cacheRemoteFeatures(
    Map<String, Feature<dynamic>> remoteFeatures,
  ) async {
    try {
      if (!config.isCacheEnabled) return;
      final cacheDataSource = dataSources.elementAt(2) as ICacheDataSource;
      if (remoteFeatures.isEmpty) return;
      await cacheDataSource.cacheFeatures(remoteFeatures);
    } catch (e, stack) {
      logger.severe('Failed to cache remote features $e', e, stack);
    }
  }

  Future<void> _initializeSource(IFeatureDataSource source) async {
    try {
      final initialize = source.initialize();
      if (config.loadTimeout != null && source is IRemoteDataSource) {
        await initialize.timeout(config.loadTimeout!, onTimeout: () {});
      } else {
        await initialize;
      }
    } catch (e, stack) {
      logger.severe('Failed to initialize source $e', e, stack);
    }
  }

  @override
  String get appVersion => _appVersion;
}
