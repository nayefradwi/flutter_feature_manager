import 'dart:async';
import 'package:flutter_feature_manager/src/domain/feature.dart';

mixin IFeatureDataSource {
  String get key;
  Future<void> initialize() async {}
  FutureOr<Map<String, Feature<dynamic>>> loadFeatures();
}

mixin IRemoteDataSource implements IFeatureDataSource {}

mixin IOverrideDataSource implements IFeatureDataSource {
  Future<void> overrideFeatures(Map<String, Feature<dynamic>> features);
  Future<void> overrideFeature(Feature<dynamic> feature);
}

mixin ICacheDataSource implements IFeatureDataSource {
  Future<void> cacheFeatures(Map<String, Feature<dynamic>> features);
  bool isExpired();
}
