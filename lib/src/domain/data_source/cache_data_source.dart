import 'dart:async';

import 'package:flutter_feature_manager/src/domain/data_source/data_source.dart';
import 'package:flutter_feature_manager/src/domain/feature.dart';

class CacheDataSource implements IFeatureDataSource {
  @override
  Future<void> initialize() async {}

  @override
  String get key => 'cache';

  @override
  FutureOr<Map<String, Feature<String>>> loadFeatures() {
    return {};
  }
}
