import 'dart:async';

import 'package:flutter_feature_manager/src/domain/data_source/data_source.dart';
import 'package:flutter_feature_manager/src/domain/feature.dart';
import 'package:flutter_feature_manager/src/domain/manager/abstract_feature_manager.dart';
import 'package:flutter_feature_manager/src/domain/manager/feature_manager_config.dart';
import 'package:flutter_feature_manager/src/utils.dart/logger.dart';

class OveriddableFeatureManager extends FeatureManager
    with IOverridableFeatureManager, IFeatureNotifier {
  final Map<String, List<FeatureListner<dynamic>>> _listeners = {};

  OveriddableFeatureManager({
    required super.remoteDataSource,
    required super.defaultsDataSource,
    super.config = const FeatureManagerConfig(),
    super.cacheDataSource,
    super.overrideDataSource,
    super.restartApp,
  });

  OveriddableFeatureManager.multipleRemoteSources({
    required super.defaultsDataSource,
    required super.remoteDataSources,
    super.config,
    super.cacheDataSource,
    super.overrideDataSource,
    super.restartApp,
  }) : super.multipleRemoteSources();

  @override
  Future<void> initialize() async {
    await super.initialize();
    for (final feature in features.values) {
      notifyFeatureListeners(current: feature, previous: null);
    }
  }

  @override
  void notifyFeatureListeners({
    required Feature<dynamic> current,
    required Feature<dynamic>? previous,
  }) {
    final listeners = _listeners[current.key] ?? [];
    for (final listener in listeners) {
      listener(previous: previous, current: current);
    }
  }

  @override
  void addFeatureListener({
    required String key,
    required FeatureListner<dynamic> listener,
  }) {
    _listeners.putIfAbsent(key, () => []).add(listener);
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

  @override
  Future<void> overrideFeature(Feature<dynamic> feature) async {
    if (!config.isOverrideEnabled) return;
    final previous = tryToGetFeature<dynamic>(feature.key);
    notifyFeatureListeners(previous: previous, current: feature);
    await saveFeatureOverride(feature);
    if (feature.requiresRestart) restartApp?.call();
  }

  @override
  Future<void> saveFeatureOverride(Feature<dynamic> feature) async {
    try {
      final overrideDataSource = dataSources.first as IOverrideDataSource;
      final override = feature.withValue<String>(feature.value.toString());
      features[feature.key] = override;
      await overrideDataSource.overrideFeature(override);
    } catch (e, stack) {
      logger.severe('Failed to save feature override $e', e, stack);
    }
  }

  @override
  Future<void> overrideFeatures(Map<String, Feature<void>> features) async {
    for (final feature in features.values) {
      await overrideFeature(feature);
    }
  }
}
