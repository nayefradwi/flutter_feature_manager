import 'package:flutter_feature_manager/src/domain/data_source.dart';
import 'package:flutter_feature_manager/src/domain/feature.dart';
import 'package:flutter_feature_manager/src/domain/feature_manager_config.dart';

abstract class IFeatureManager {
  final List<IFeatureDataSource> dataSources;
  final AbstractFeatureManagerConfig config;
  Future<void> initialize();
  AbstractFeature<T> getFeature<T>(String key);

  IFeatureManager({
    required this.dataSources,
    required this.config,
  });
}
