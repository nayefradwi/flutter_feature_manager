import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_feature_manager/src/domain/feature.dart';

mixin IFeatureParser<T> {
  Feature<String> parse(String key, T data);
}

class JsonFeatureParser implements IFeatureParser<Map<String, dynamic>> {
  final String valueKey;
  final String? minVersionKey;
  final String? maxVersionKey;
  final String? descriptionKey;
  JsonFeatureParser({
    required this.valueKey,
    this.minVersionKey,
    this.maxVersionKey,
    this.descriptionKey,
  });

  @override
  Feature<String> parse(String key, Map<String, dynamic> data) {
    final value = data[valueKey] as String? ?? '';
    final minVersion = data[minVersionKey ?? ''] as String?;
    final maxVersion = data[maxVersionKey ?? ''] as String?;
    final description = data[descriptionKey ?? ''] as String?;
    return Feature(
      key: key,
      value: value,
      minVersion: minVersion,
      maxVersion: maxVersion,
      description: description,
    );
  }
}

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
