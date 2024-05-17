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

mixin IRemoteDataSource on IFeatureDataSource {}
mixin IOverrideDataSource on IFeatureDataSource {
  Future<void> overrideFeatures(Map<String, Feature<String>> features);
}

mixin ICacheDataSource on IFeatureDataSource {
  Future<void> cacheFeatures(Map<String, Feature<String>> feature);
  bool isExpired();
}
