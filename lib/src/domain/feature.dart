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

  S parseValue<S>() {
    final value = this.value.toString();
    return switch (S) {
      String => value as S,
      int => int.tryParse(value) as S? ?? 0 as S,
      double => double.tryParse(value) as S? ?? 0.0 as S,
      bool => bool.tryParse(value) as S? ?? false as S,
      _ => throw Exception('Unsupported type'),
    };
  }

  S getDefaultValue<S>() {
    return switch (S) {
      String => '' as S,
      int => 0 as S,
      double => 0.0 as S,
      bool => false as S,
      _ => throw Exception('Unsupported type'),
    };
  }

  static Type getTypeOfValue(dynamic value) {
    final asInt = int.tryParse(value.toString());
    if (asInt != null) return int;
    final asDouble = double.tryParse(value.toString());
    if (asDouble != null) return double;
    final asBool = bool.tryParse(value.toString());
    if (asBool != null) return bool;
    return String;
  }
}
