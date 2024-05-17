import 'package:flutter_feature_manager/src/domain/feature.dart';
import 'package:flutter_feature_manager/src/domain/parser/feature_parser.dart';

class JsonFeatureParser implements IFeatureParser<Map<String, dynamic>> {
  final String valueKey;
  final String? minVersionKey;
  final String? maxVersionKey;
  final String? descriptionKey;
  final String? requiresRestartKey;
  JsonFeatureParser({
    required this.valueKey,
    this.minVersionKey,
    this.maxVersionKey,
    this.descriptionKey,
    this.requiresRestartKey,
  });

  @override
  Feature<String> parse(String key, dynamic data) {
    if (data is String) return Feature(key: key, value: data);
    if (data is! Map<String, dynamic>) return Feature(key: key, value: '');
    final value = data[valueKey] as String? ?? '';
    final minVersion = data[minVersionKey ?? ''] as String?;
    final maxVersion = data[maxVersionKey ?? ''] as String?;
    final description = data[descriptionKey ?? ''] as String?;
    final requiresRestart = data[requiresRestartKey ?? ''] as bool? ?? false;
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
    if (minVersionKey != null) json[minVersionKey!] = feature.minVersion;
    if (maxVersionKey != null) json[maxVersionKey!] = feature.maxVersion;
    if (descriptionKey != null) json[descriptionKey!] = feature.description;
    if (requiresRestartKey != null) {
      json[requiresRestartKey!] = feature.requiresRestart;
    }
    return json;
  }
}
