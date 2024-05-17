import 'package:flutter_feature_manager/src/domain/feature.dart';

mixin IFeatureParser<T> {
  Feature<String> parse(String key, T data);
}
