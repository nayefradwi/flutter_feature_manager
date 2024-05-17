import 'package:flutter_feature_manager/src/domain/feature.dart';

mixin IFeatureDataSource {
  Future<void> initialize() async {}
  Future<Map<String, AbstractFeature<dynamic>>> loadFeatures();
}
