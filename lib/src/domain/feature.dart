// TODO: should be a regular class?
abstract class AbstractFeature<T> {
  final T value;
  final String key;
  final String? minVersion;
  final String? maxVersion;
  final String? description;

  AbstractFeature({
    required this.value,
    required this.key,
    this.description,
    this.minVersion,
    this.maxVersion,
  });
}
