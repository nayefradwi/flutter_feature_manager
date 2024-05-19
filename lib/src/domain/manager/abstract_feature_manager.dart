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
  Future<void> overrideFeature<T>(Feature<T> feature);
  Future<void> saveFeatureOverride<T>(Feature<T> feature);
}

mixin IFeatureNotifier {
  void notifyFeatureListeners<T>({
    required Feature<T>? previous,
    required Feature<T> current,
  });

  void addFeatureListener<T>({
    required String key,
    required FeatureListner<T> listener,
  });

  void removeFeatureListener<T>({
    required String key,
    required FeatureListner<T> listener,
  });
}

abstract class IFeatureManager {
  final List<IFeatureDataSource> dataSources;
  final FeatureManagerConfig config;
  final Map<String, Map<String, Feature<dynamic>>> features;
  final void Function()? restartApp;
  String get appVersion;

  IFeatureManager({
    required this.dataSources,
    required this.config,
    Map<String, Map<String, Feature<String>>>? features,
    this.restartApp,
  }) : features = features ?? {};

  Future<void> initialize();

  Feature<T>? tryToGetFeature<T>(String key);

  Feature<T> getFeature<T>(String key, {required T defaultValue});

  List<Feature<dynamic>> getFeatures() {
    final features = <String, Feature<dynamic>>{};
    for (final source in dataSources) {
      features.addAll(this.features[source.key] ?? {});
    }
    return features.values.toList();
  }
}
