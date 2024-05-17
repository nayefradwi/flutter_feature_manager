import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_feature_manager/src/domain/feature.dart';
import 'package:flutter_feature_manager/src/domain/parser/feature_parser.dart';
import 'package:flutter_feature_manager/src/domain/parser/json_feature_parser.dart';

class FirebaseRemoteConfigFeatureParser
    implements IFeatureParser<RemoteConfigValue> {
  final JsonFeatureParser _jsonFeatureParser;

  FirebaseRemoteConfigFeatureParser({
    required String valueKey,
    String? minVersionKey,
    String? maxVersionKey,
    String? descriptionKey,
  }) : _jsonFeatureParser = JsonFeatureParser(
          valueKey: valueKey,
          minVersionKey: minVersionKey,
          maxVersionKey: maxVersionKey,
          descriptionKey: descriptionKey,
        );

  @override
  Feature<String> parse(String key, RemoteConfigValue data) {
    final jsonMap = _valueToJson(data);
    if (jsonMap != null) return _jsonFeatureParser.parse(key, jsonMap);
    final value = data.asString();
    return Feature(key: key, value: value);
  }

  Map<String, dynamic>? _valueToJson(RemoteConfigValue value) {
    try {
      final jsonString = value.asString();
      final jsonMap = jsonDecode(jsonString);
      if (jsonMap is! Map<String, dynamic>) return null;
      return jsonMap;
    } catch (e) {
      return null;
    }
  }
}
