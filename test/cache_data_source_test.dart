import 'dart:convert';

import 'package:flutter_feature_manager/flutter_feature_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void _setupSharedPreferences({
  Map<String, dynamic>? features,
  DateTime? expiration,
}) {
  final testFeatureFlag = {
    'feature1': 'true',
    'feature2': {
      'value': 'false',
      'description': 'This is a test feature flag',
    },
  };
  final testExpiration = DateTime.now().add(const Duration(hours: 1));

  SharedPreferences.setMockInitialValues({
    'cached_features': jsonEncode(features ?? testFeatureFlag),
    'cache_expiration':
        expiration?.toIso8601String() ?? testExpiration.toIso8601String(),
  });
}

void main() {
  final cacheDataSource = CacheDataSource();

  setUp(_setupSharedPreferences);

  test('should load cached feature flags if not expired', () async {
    await cacheDataSource.initialize();
    final features = await cacheDataSource.loadFeatures();
    expect(features.length, 2);
    expect(features['feature1']!.value, 'true');
    expect(features['feature2']!.value, 'false');
    expect(features['feature2']!.description, 'This is a test feature flag');
  });

  test('should return empty map if cache is expired', () async {
    final expiredDate = DateTime.now().subtract(const Duration(hours: 1));
    _setupSharedPreferences(expiration: expiredDate);
    await cacheDataSource.initialize();
    final features = await cacheDataSource.loadFeatures();
    expect(features, isEmpty);
  });

  test('should store new cached features', () async {
    await cacheDataSource.initialize();
    final newFeature = Feature<String>(
      key: 'feature3',
      value: 'true',
      description: 'This is a new feature flag',
    );
    await cacheDataSource.cacheFeatures({'feature3': newFeature});
    final features = await cacheDataSource.loadFeatures();
    expect(features.length, 1);
    expect(features['feature3']!.value, 'true');
    expect(features['feature3']!.description, 'This is a new feature flag');
  });

  test('should fail if not initialized', () async {
    final cacheDataSource = CacheDataSource();
    final features = await cacheDataSource.loadFeatures();
    expect(features, isEmpty);
  });
}
