part of 'abstract_feature_manager.dart';

class FeatureManager extends IFeatureManager {
  final Map<String, List<FeatureListner<dynamic>>> _listeners = {};

  String _appVersion = '';
  FeatureManager({
    required IFeatureDataSource remoteDataSource,
    required IFeatureDataSource defaultsDataSource,
    super.config = const FeatureManagerConfig(),
    CacheDataSource? cacheDataSource,
    IOverrideDataSource? overrideDataSource,
  }) : super(
          dataSources: [
            if (config.isOverrideEnabled)
              overrideDataSource ?? OverrideDataSource(),
            remoteDataSource,
            if (config.isCacheEnabled) cacheDataSource ?? CacheDataSource(),
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
      if (!feature.isVersionEnabled(appVersion)) {
        return feature.withValue(_getDefaultValue());
      }
      final value = _parseValue<T>(feature);
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

  T _parseValue<T>(Feature<String> feature) {
    return switch (T) {
      String => feature.value as T,
      int => int.tryParse(feature.value) as T? ?? 0 as T,
      double => double.tryParse(feature.value) as T? ?? 0.0 as T,
      bool => bool.tryParse(feature.value) as T? ?? false as T,
      _ => throw Exception('Unsupported type'),
    };
  }

  T _getDefaultValue<T>() {
    return switch (T) {
      String => '' as T,
      int => 0 as T,
      double => 0.0 as T,
      bool => false as T,
      _ => throw Exception('Unsupported type'),
    };
  }

  @override
  Future<void> initialize() async {
    final packageInfo = await PackageInfo.fromPlatform();
    _appVersion = packageInfo.version;
    for (final source in dataSources) {
      await _initializeSource(source);
      final features = await source.loadFeatures();
      this.features[source.key] = features;
    }
    unawaited(_cacheRemoteFeatures());
  }

  Future<void> _cacheRemoteFeatures() async {
    try {
      if (!config.isCacheEnabled) return;
      final remoteDataSource = dataSources.elementAt(1) as IRemoteDataSource;
      final cacheDataSource = dataSources.elementAt(2) as ICacheDataSource;
      final remoteFeatures = features[remoteDataSource.key];
      if (remoteFeatures?.isEmpty ?? true) return;
      features[cacheDataSource.key] = remoteFeatures!;
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

  @override
  Future<void> saveFeatureOverride<T>(Feature<T> feature) async {
    try {
      final overrideDataSource = dataSources.first as IOverrideDataSource;
      final override = feature.withValue<String>(feature.value.toString());
      final overriddenFeatures = features[overrideDataSource.key] ?? {};
      overriddenFeatures[feature.key] = override;
      await overrideDataSource.overrideFeatures(overriddenFeatures);
    } catch (e, stack) {
      logger.severe('Failed to save feature override $e', e, stack);
    }
  }

  // @override
  // void addFeatureListener<T>({
  //   required String key,
  //   required FeatureListner listener,
  // }) {
  //
  // }

  @override
  void notifyFeatureListeners<T>({
    required Feature<T> current,
    required Feature<T>? previous,
  }) {
    final listeners = _listeners[current.key] ?? [];
    for (final listener in listeners) {
      listener(previous: previous, current: current);
    }
  }

  @override
  void addFeatureListener<T>({
    required String key,
    required FeatureListner<T> listener,
  }) {
    _listeners.putIfAbsent(key, () => []).add(listener as FeatureListner);
  }

  @override
  void removeFeatureListener<T>({
    required String key,
    required FeatureListner<T> listener,
  }) {
    final listeners = _listeners[key];
    if (listeners == null) return;
    listeners.remove(listener);
    if (listeners.isEmpty) {
      _listeners.remove(key);
    }
  }
}
