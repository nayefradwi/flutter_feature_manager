import 'package:flutter_feature_manager/src/domain/data_source/cache_data_source.dart';
import 'package:flutter_feature_manager/src/domain/data_source/data_source.dart';
import 'package:flutter_feature_manager/src/domain/data_source/override_data_source.dart';
import 'package:flutter_feature_manager/src/domain/feature.dart';
import 'package:flutter_feature_manager/src/domain/feature_manager_config.dart';

abstract class IFeatureManager {
  final List<IFeatureDataSource> dataSources;
  final AbstractFeatureManagerConfig config;
  Map<String, Map<String, Feature<String>>> _features = {};
  Future<void> initialize();
  Feature<T> getFeature<T>(String key);

  IFeatureManager({
    required this.dataSources,
    required this.config,
  });
}

class FeatureManager extends IFeatureManager {
  FeatureManager({
    required IFeatureDataSource remoteDataSource,
    required IFeatureDataSource defaultsDataSource,
    required super.config,
    IFeatureDataSource? cacheDataSource,
    IFeatureDataSource? overrideDataSource,
  }) : super(
          dataSources: [
            overrideDataSource ?? OverrideDataSource(),
            remoteDataSource,
            cacheDataSource ?? CacheDataSource(),
            defaultsDataSource,
          ],
        );

  @override
  Feature<T> getFeature<T>(String key) {
    // 1. get override feature
    // 2. if override null; get remote feature
    // 3. if remote null; get cache feature
    // 4. if cache null; get default feature
    // 5. if default null; return empty feature
    // TODO: implement getFeature
    throw UnimplementedError();
  }

  @override
  Future<void> initialize() async {
    // 1. initialize all data sources
    // 2. loop through all data sources and load features
    // 3. take into consideration config
  }
}
