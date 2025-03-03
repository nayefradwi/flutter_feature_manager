import 'dart:convert';
import 'dart:developer';

import 'package:flutter_feature_manager/src/domain/feature.dart';
import 'package:flutter_feature_manager/src/domain/parser/feature_parser.dart';

const defaultValueKey = 'value';
const defaultMinVersionKey = 'min_version';
const defaultMaxVersionKey = 'max_version';
const defaultDescriptionKey = 'description';
const defaultRequiresRestartKey = 'requires_restart';
const defaultMetadataKey = 'metadata';

class JsonFeatureParser implements IFeatureParser<Map<String, dynamic>> {
  final String valueKey;
  final String minVersionKey;
  final String maxVersionKey;
  final String descriptionKey;
  final String requiresRestartKey;
  final String metadataKey;
  JsonFeatureParser({
    this.valueKey = defaultValueKey,
    this.minVersionKey = defaultMinVersionKey,
    this.maxVersionKey = defaultMaxVersionKey,
    this.descriptionKey = defaultDescriptionKey,
    this.requiresRestartKey = defaultRequiresRestartKey,
    this.metadataKey = defaultMetadataKey,
  });

  @override
  Feature<String> parse(String key, dynamic data) {
    if (data is String) return Feature(key: key, value: data);
    if (data is num) return Feature(key: key, value: data.toString());
    if (data is bool) return Feature(key: key, value: data.toString());
    if (data is! Map<String, dynamic>) return Feature(key: key, value: '');
    final value = data[valueKey] as String? ?? '';
    final minVersion = data[minVersionKey] as String?;
    final maxVersion = data[maxVersionKey] as String?;
    final description = data[descriptionKey] as String?;
    final requiresRestart = data[requiresRestartKey] as bool? ?? false;
    final metadata = _loadMetadata(data);
    return Feature(
      key: key,
      value: value,
      minVersion: minVersion,
      maxVersion: maxVersion,
      description: description,
      requiresRestart: requiresRestart,
      metadata: metadata,
    );
  }

  Map<String, dynamic> _loadMetadata(Map<String, dynamic> json) {
    try {
      final metadata = json[metadataKey];
      if (metadata is String) {
        return jsonDecode(metadata) as Map<String, dynamic>;
      }
      if (metadata is Map<String, dynamic>) {
        return metadata;
      }
      return {};
    } catch (e, stack) {
      log('Failed to load metadata: $e', error: e, stackTrace: stack);
      return {};
    }
  }

  Map<String, dynamic> toJson(Feature<dynamic> feature) {
    final json = <String, dynamic>{valueKey: feature.value};
    json[minVersionKey] = feature.minVersion;
    json[maxVersionKey] = feature.maxVersion;
    json[descriptionKey] = feature.description;
    json[requiresRestartKey] = feature.requiresRestart;
    json[metadataKey] = _metadataToJson(feature.metadata);
    return json;
  }

  String _metadataToJson(Map<String, dynamic> metadata) {
    try {
      return jsonEncode(metadata);
    } catch (e, stack) {
      log(
        'Failed to convert metadata to JSON: $e',
        error: e,
        stackTrace: stack,
      );
      return '{}';
    }
  }
}
