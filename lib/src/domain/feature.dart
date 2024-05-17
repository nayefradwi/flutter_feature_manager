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
}
