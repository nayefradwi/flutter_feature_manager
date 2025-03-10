import 'dart:async';

import 'package:flutter_feature_manager/src/domain/data_source/cache_data_source.dart';
import 'package:flutter_feature_manager/src/domain/data_source/data_source.dart';
import 'package:flutter_feature_manager/src/domain/data_source/override_data_source.dart';
import 'package:flutter_feature_manager/src/domain/feature.dart';
import 'package:flutter_feature_manager/src/domain/manager/feature_manager_config.dart';
import 'package:flutter_feature_manager/src/utils.dart/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
part 'feature_manager.dart';

typedef FeatureListner<T> = void Function({
  required Feature<T>? previous,
  required Feature<T> current,
});

mixin IOverridableFeatureManager {
  Future<void> overrideFeature(Feature<dynamic> feature);
  Future<void> overrideFeatures(Map<String, Feature<dynamic>> features);
  Future<void> saveFeatureOverride(Feature<dynamic> feature);
}

mixin IFeatureNotifier {
  void notifyFeatureListeners({
    required Feature<dynamic>? previous,
    required Feature<dynamic> current,
  });

  void addFeatureListener({
    required String key,
    required FeatureListner<dynamic> listener,
  });

  void removeFeatureListener<T>({
    required String key,
    required FeatureListner<T> listener,
  });
}

abstract class IFeatureManager {
  final List<IFeatureDataSource> dataSources;
  final FeatureManagerConfig config;
  final Map<String, Feature<dynamic>> features;
  final void Function()? restartApp;
  String get appVersion;

  IFeatureManager({
    required this.dataSources,
    required this.config,
    Map<String, Feature<String>>? features,
    this.restartApp,
  }) : features = features ?? {};

  Future<void> initialize();

  Feature<T>? tryToGetFeature<T>(String key);

  Feature<T> getFeature<T>(String key, {required T defaultValue});

  List<Feature<dynamic>> getFeatures() {
    return features.values.toList();
  }
}
