import 'dart:async';
import 'package:flutter_feature_manager/src/domain/feature.dart';

// four data sources:
// 1. overrideFeatureDataSource
// 3. LocalDataSource
// 4. InMemoryDataSource
mixin IFeatureDataSource {
  String get key;
  Future<void> initialize() async {}
  FutureOr<Map<String, Feature<String>>> loadFeatures();
}

mixin IOverrideDataSource on IFeatureDataSource {
  Future<void> overrideFeature<T>(Feature<T> feature);
}

mixin ICacheDataSource on IFeatureDataSource {
  Future<void> cacheFeature<T>(Feature<T> feature);
}
