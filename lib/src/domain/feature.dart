import 'package:flutter_feature_manager/src/utils.dart/version.dart';

class Feature<T> {
  final T value;
  final String key;
  final String? minVersion;
  final String? maxVersion;
  final String? description;
  final bool requiresRestart;

  Feature({
    required this.value,
    required this.key,
    this.description,
    this.minVersion,
    this.maxVersion,
    this.requiresRestart = false,
  });

  static Feature<String> empty(String key) => Feature(value: '', key: key);

  Feature<S> withValue<S>(
    S value, {
    String? minVersion,
    String? maxVersion,
  }) {
    return Feature<S>(
      value: value,
      key: key,
      description: description,
      minVersion: minVersion ?? this.minVersion,
      maxVersion: maxVersion ?? this.maxVersion,
      requiresRestart: requiresRestart,
    );
  }

  bool _isLowerThanMin(String version) {
    if (minVersion == null) return false;
    final bigger = compareVersions(version1: version, version2: minVersion!);
    return bigger == minVersion;
  }

  bool _isHigherThanMax(String version) {
    if (maxVersion == null) return false;
    final bigger = compareVersions(version1: version, version2: maxVersion!);
    return bigger == version;
  }

  bool isVersionEnabled(String version) {
    return !_isLowerThanMin(version) && !_isHigherThanMax(version);
  }
}
