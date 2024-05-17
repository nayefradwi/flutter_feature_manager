import 'dart:async';

import 'package:flutter_feature_manager/src/domain/data_source/data_source.dart';
import 'package:flutter_feature_manager/src/domain/feature.dart';

class DefaultsDataSource with IFeatureDataSource {
  final Map<String, Feature<String>> defaultFeatures;

  DefaultsDataSource({
    required this.defaultFeatures,
  });

  @override
  String get key => 'defaults';

  @override
  FutureOr<Map<String, Feature<String>>> loadFeatures() => defaultFeatures;
}
