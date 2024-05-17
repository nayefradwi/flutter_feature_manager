import 'dart:async';

import 'package:flutter_feature_manager/src/domain/data_source/cache_data_source.dart';
import 'package:flutter_feature_manager/src/domain/data_source/data_source.dart';
import 'package:flutter_feature_manager/src/domain/data_source/override_data_source.dart';
import 'package:flutter_feature_manager/src/domain/feature.dart';
import 'package:flutter_feature_manager/src/domain/manager/feature_manager_config.dart';
import 'package:flutter_feature_manager/src/utils.dart/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
part 'feature_manager.dart';

abstract class IFeatureManager {
  final List<IFeatureDataSource> dataSources;
  final FeatureManagerConfig config;
  final Map<String, Map<String, Feature<String>>> features;
  String get appVersion;

  IFeatureManager({
    required this.dataSources,
    required this.config,
    Map<String, Map<String, Feature<String>>>? features,
  }) : features = features ?? {};

  Future<void> initialize();

  Feature<T>? tryToGetFeature<T>(String key);

  Feature<T> getFeature<T>(String key, {required T defaultValue});

  Future<void> overrideFeature<T>(Feature<T> feature) async {
    if (!config.isOverrideEnabled) return;
    return saveFeatureOverride(feature);
  }

  Future<void> saveFeatureOverride<T>(Feature<T> feature) async {}
}
