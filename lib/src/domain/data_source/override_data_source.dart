import 'dart:async';
import 'dart:convert';

import 'package:flutter_feature_manager/src/domain/data_source/data_source.dart';
import 'package:flutter_feature_manager/src/domain/feature.dart';
import 'package:flutter_feature_manager/src/domain/parser/json_feature_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OverrideDataSource implements IOverrideDataSource {
  static const _overrideFeaturesKey = 'override_features';
  SharedPreferences? _preferences;
  final _jsonParser = JsonFeatureParser(valueKey: 'value');

  @override
  Future<void> initialize() async {
    _preferences = await SharedPreferences.getInstance();
  }

  @override
  String get key => 'override';

  @override
  FutureOr<Map<String, Feature<String>>> loadFeatures() async {
    try {
      if (_preferences == null) return {};
      final featuresString = _preferences!.getString(_overrideFeaturesKey);
      if (featuresString == null) return {};
      final featuresJson = jsonDecode(featuresString) as Map<String, dynamic>;
      final features = <String, Feature<String>>{};
      for (final entry in featuresJson.entries) {
        final key = entry.key;
        final value = entry.value;
        final feature = _jsonParser.parse(key, value);
        features[key] = feature;
      }
      return features;
    } catch (e) {
      // TODO: log error
      return {};
    }
  }

  @override
  Future<void> overrideFeature<T>(Feature<T> feature) {
    // TODO: implement overrideFeature
    throw UnimplementedError();
  }
}
