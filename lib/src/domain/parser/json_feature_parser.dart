import 'package:flutter_feature_manager/src/domain/feature.dart';
import 'package:flutter_feature_manager/src/domain/parser/feature_parser.dart';

const defaultValueKey = 'value';
const defaultMinVersionKey = 'min_version';
const defaultMaxVersionKey = 'max_version';
const defaultDescriptionKey = 'description';
const defaultRequiresRestartKey = 'requires_restart';

class JsonFeatureParser implements IFeatureParser<Map<String, dynamic>> {
  final String valueKey;
  final String minVersionKey;
  final String maxVersionKey;
  final String descriptionKey;
  final String requiresRestartKey;
  JsonFeatureParser({
    this.valueKey = defaultValueKey,
    this.minVersionKey = defaultMinVersionKey,
    this.maxVersionKey = defaultMaxVersionKey,
    this.descriptionKey = defaultDescriptionKey,
    this.requiresRestartKey = defaultRequiresRestartKey,
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
    return Feature(
      key: key,
      value: value,
      minVersion: minVersion,
      maxVersion: maxVersion,
      description: description,
      requiresRestart: requiresRestart,
    );
  }

  Map<String, dynamic> toJson(Feature<String> feature) {
    final json = <String, dynamic>{valueKey: feature.value};
    json[minVersionKey] = feature.minVersion;
    json[maxVersionKey] = feature.maxVersion;
    json[descriptionKey] = feature.description;
    json[requiresRestartKey] = feature.requiresRestart;
    return json;
  }
}
