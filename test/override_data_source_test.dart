import 'dart:convert';

import 'package:flutter_feature_manager/flutter_feature_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SharedPreferences.setMockInitialValues({'override_features': {}});
  final overrideDataSource = OverrideDataSource();

  test('should override feature if initialized', () async {
    await overrideDataSource.initialize();
    final newFeature = Feature<String>(
      key: 'feature1',
      value: 'true',
      description: 'This is a new feature flag',
    );
    await overrideDataSource.overrideFeatures({'feature1': newFeature});
    final features = await overrideDataSource.loadFeatures();
    expect(features.length, 1);
    expect(features['feature1']!.value, 'true');
  });

  test('should not return features if not initialized', () async {
    final jsonFeature = jsonEncode({'feature1': 'true'});
    SharedPreferences.setMockInitialValues({'override_features': jsonFeature});
    final overrideDataSource = OverrideDataSource();
    final features = await overrideDataSource.loadFeatures();
    expect(features, isEmpty);
  });
}
