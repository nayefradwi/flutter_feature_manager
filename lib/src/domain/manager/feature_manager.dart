part of 'abstract_feature_manager.dart';

class FeatureManager extends IFeatureManager {
  String _appVersion = '';
  FeatureManager({
    required IFeatureDataSource remoteDataSource,
    required IFeatureDataSource defaultsDataSource,
    FeatureManagerConfig? config,
    CacheDataSource? cacheDataSource,
    IOverrideDataSource? overrideDataSource,
  }) : super(
          config: config ?? FeatureManagerConfig(),
          dataSources: [
            overrideDataSource ?? OverrideDataSource(),
            remoteDataSource,
            cacheDataSource ?? CacheDataSource(),
            defaultsDataSource,
          ],
        );

  @override
  Feature<T>? tryToGetFeature<T>(String key) {
    try {
      Feature<String>? feature;
      for (final source in dataSources) {
        feature = features[source.key]?[key];
        if (feature != null) break;
      }
      feature ??= Feature.empty(key);
      final value = _parseValue<T>(feature);
      return feature.withValue<T>(value);
    } catch (e) {
      // TODO: log error
      return null;
    }
  }

  @override
  Feature<T> getFeature<T>(String key, {required T defaultValue}) {
    final feature = tryToGetFeature<T>(key);
    return feature ?? Feature(key: key, value: defaultValue);
  }

  T _parseValue<T>(Feature<String> feature) {
    return switch (T) {
      String => feature.value as T,
      int => int.tryParse(feature.value) as T? ?? 0 as T,
      double => double.tryParse(feature.value) as T? ?? 0.0 as T,
      bool => bool.tryParse(feature.value) as T? ?? false as T,
      _ => throw Exception('Unsupported type'),
    };
  }

  @override
  Future<void> initialize() async {
    final packageInfo = await PackageInfo.fromPlatform();
    _appVersion = packageInfo.version;
    // 1. initialize all data sources
    // 2. loop through all data sources and load features
    // 3. take into consideration config
    // 4. set up app version
  }

  @override
  String get appVersion => _appVersion;

  @override
  Future<void> saveFeatureOverride<T>(Feature<T> feature) async {
    try {
      final overrideDataSource = dataSources.first as IOverrideDataSource;
      final override = feature.withValue<String>(feature.value.toString());
      features[overrideDataSource.key]?[feature.key] = override;
      await overrideDataSource.overrideFeature(override);
    } catch (e) {
      // TODO: log error
    }
  }
}
