import 'package:flutter_feature_manager/flutter_feature_manager.dart';
import 'package:flutter_feature_manager/src/domain/parser/json_feature_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('default json parser', () {
    final jsonParser = JsonFeatureParser();
    test('should parse all fields correctly', () {
      final json = {
        defaultValueKey: 'value',
        defaultMinVersionKey: '1.0.0',
        defaultMaxVersionKey: '2.0.0',
        defaultDescriptionKey: 'description',
        defaultRequiresRestartKey: true,
      };

      final feature = jsonParser.parse('key', json);

      expect(feature.key, 'key');
      expect(feature.value, 'value');
      expect(feature.minVersion, '1.0.0');
      expect(feature.maxVersion, '2.0.0');
      expect(feature.description, 'description');
      expect(feature.requiresRestart, true);
    });

    test('should set defaults', () {
      const json = <String, dynamic>{};

      final feature = jsonParser.parse('key', json);

      expect(feature.key, 'key');
      expect(feature.value, '');
      expect(feature.minVersion, null);
      expect(feature.maxVersion, null);
      expect(feature.description, null);
      expect(feature.requiresRestart, false);
    });

    test('should set string as value', () {
      const json = 'test';

      final feature = jsonParser.parse('key', json);

      expect(feature.key, 'key');
      expect(feature.value, 'test');
      expect(feature.minVersion, null);
      expect(feature.maxVersion, null);
      expect(feature.description, null);
      expect(feature.requiresRestart, false);
    });

    test('should return empty value at unknown data type', () {
      final json = ['t', 'e', 's', 't'];

      final feature = jsonParser.parse('key', json);

      expect(feature.key, 'key');
      expect(feature.value, '');
    });
  });

  group('custom json parser', () {
    final jsonParser = JsonFeatureParser(
      minVersionKey: 'min',
      maxVersionKey: 'max',
      descriptionKey: 'desc',
      requiresRestartKey: 'restart',
    );

    test('should parse fields correctly', () {
      final json = {
        'value': 'value',
        'min': '1.0.0',
        'max': '2.0.0',
        'desc': 'description',
        'restart': true,
      };

      final feature = jsonParser.parse('key', json);

      expect(feature.key, 'key');
      expect(feature.value, 'value');
      expect(feature.minVersion, '1.0.0');
      expect(feature.maxVersion, '2.0.0');
      expect(feature.description, 'description');
      expect(feature.requiresRestart, true);
    });

    test('should fill in defaults', () {
      const json = <String, dynamic>{};

      final feature = jsonParser.parse('key', json);

      expect(feature.key, 'key');
      expect(feature.value, '');
      expect(feature.minVersion, null);
      expect(feature.maxVersion, null);
      expect(feature.description, null);
      expect(feature.requiresRestart, false);
    });
  });
}
