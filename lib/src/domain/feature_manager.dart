import 'package:flutter_feature_manager/src/domain/data_source/cache_data_source.dart';
import 'package:flutter_feature_manager/src/domain/data_source/data_source.dart';
import 'package:flutter_feature_manager/src/domain/data_source/override_data_source.dart';
import 'package:flutter_feature_manager/src/domain/feature.dart';
import 'package:flutter_feature_manager/src/domain/feature_manager_config.dart';

// TODO: load app version
abstract class IFeatureManager {
  // TODO: should override be here?
  final List<IFeatureDataSource> dataSources;
  final FeatureManagerConfig config;
  Map<String, Map<String, Feature<String>>> _features = {};
  Future<void> initialize();
  Feature<T> getFeature<T>(String key);
  String get appVersion;
  IFeatureManager({
    required this.dataSources,
    required this.config,
  });
}

class FeatureManager extends IFeatureManager {
  String _appVersion = '';
  FeatureManager({
    required IFeatureDataSource remoteDataSource,
    required IFeatureDataSource defaultsDataSource,
    FeatureManagerConfig? config,
    IFeatureDataSource? cacheDataSource,
    IFeatureDataSource? overrideDataSource,
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
  Feature<T> getFeature<T>(String key) {
    Feature<String>? feature;
    for (final source in dataSources) {
      feature = _features[source.key]?[key];
      if (feature != null) break;
    }
    feature ??= Feature.empty(key);
    final value = _parseValue<T>(feature);
    return feature.withValue<T>(value);
  }

  T _parseValue<T>(Feature<String> feature) {
    throw UnimplementedError();
  }

  @override
  Future<void> initialize() async {
    // 1. initialize all data sources
    // 2. loop through all data sources and load features
    // 3. take into consideration config
  }

  @override
  String get appVersion => _appVersion;
}
