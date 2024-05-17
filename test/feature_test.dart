import 'package:flutter_feature_manager/flutter_feature_manager.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final mockFeature = Feature(
    value: 'test',
    key: 'key',
    minVersion: '1.0.0',
    maxVersion: '2.0.0',
  );

  test('should return false when version is lower than min', () {
    final result = mockFeature.isVersionEnabled('0.9.9');
    expect(result, false);
  });

  test('should return false when version is equal to min', () {
    final result = mockFeature.isVersionEnabled('1.0.0');
    expect(result, false);
  });

  test('should return true when version is between min and max', () {
    final result = mockFeature.isVersionEnabled('1.0.1');
    expect(result, true);
  });

  test('should return false when version is equal to max', () {
    final result = mockFeature.isVersionEnabled('2.0.0');
    expect(result, false);
  });

  test('should return false when version is higher than max', () {
    final result = mockFeature.isVersionEnabled('2.0.1');
    expect(result, false);
  });
}
