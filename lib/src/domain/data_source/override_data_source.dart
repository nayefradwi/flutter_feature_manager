import 'dart:async';

import 'package:flutter_feature_manager/src/domain/data_source/data_source.dart';
import 'package:flutter_feature_manager/src/domain/feature.dart';

class OverrideDataSource implements IFeatureDataSource {
  @override
  Future<void> initialize() {
    // TODO: implement initialize
    throw UnimplementedError();
  }

  @override
  String get key => 'override';

  @override
  FutureOr<Map<String, Feature<String>>> loadFeatures() {
    // TODO: implement loadFeatures
    throw UnimplementedError();
  }
}
