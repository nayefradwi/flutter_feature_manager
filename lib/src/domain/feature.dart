class Feature<T> {
  final T value;
  final String key;
  final String? minVersion;
  final String? maxVersion;
  final String? description;
  final bool? requiresRestart;

  Feature({
    required this.value,
    required this.key,
    this.description,
    this.minVersion,
    this.maxVersion,
    this.requiresRestart,
  });

  static Feature<String> empty(String key) => Feature(value: '', key: key);

  Feature<S> withValue<S>(S value) {
    return Feature<S>(
      value: value,
      key: key,
      description: description,
      minVersion: minVersion,
      maxVersion: maxVersion,
      requiresRestart: requiresRestart,
    );
  }
  // TODO: implement compare versions
}
