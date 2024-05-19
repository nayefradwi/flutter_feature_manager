import 'dart:async';
import 'dart:convert';

import 'package:flutter_feature_manager/src/domain/data_source/data_source.dart';
import 'package:flutter_feature_manager/src/domain/feature.dart';
import 'package:flutter_feature_manager/src/domain/parser/json_feature_parser.dart';
import 'package:flutter_feature_manager/src/utils.dart/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheDataSource implements ICacheDataSource {
  static const _cacheExpirationKey = 'cache_expiration';
  static const _cachedfeaturesKey = 'cached_features';
  final Duration cacheDuration;
  final JsonFeatureParser _jsonParser;
  SharedPreferences? _preferences;

  CacheDataSource({
    this.cacheDuration = const Duration(hours: 1),
    JsonFeatureParser? jsonParser,
  }) : _jsonParser = jsonParser ?? JsonFeatureParser();

  @override
  Future<void> initialize() async {
    _preferences = await SharedPreferences.getInstance();
  }

  @override
  String get key => 'cache';

  @override
  FutureOr<Map<String, Feature<String>>> loadFeatures() {
    try {
      if (_preferences == null) return {};
      if (isExpired()) return {};
      final featuresString = _preferences!.getString(_cachedfeaturesKey);
      if (featuresString == null) return {};
      final featuresJson = jsonDecode(featuresString) as Map<String, dynamic>;
      final features = <String, Feature<String>>{};
      for (final entry in featuresJson.entries) {
        final key = entry.key;
        final value = entry.value;
        final feature = _jsonParser.parse(key, value);
        features[key] = feature;
      }
      return features;
    } catch (e, stack) {
      logger.severe(
        'Failed to load features from SharedPreferences: $e',
        e,
        stack,
      );
      return {};
    }
  }

  @override
  bool isExpired() {
    if (_preferences == null) return true;
    final expirationString = _preferences!.getString(_cacheExpirationKey);
    if (expirationString == null) return true;
    final expiry = DateTime.tryParse(expirationString);
    if (expiry == null) return true;
    final now = DateTime.now();
    return now.isAfter(expiry);
  }

  @override
  Future<void> cacheFeatures(Map<String, Feature<dynamic>> features) async {
    try {
      final featuresJson = <String, dynamic>{};
      for (final entry in features.entries) {
        final key = entry.key;
        final value = _jsonParser.toJson(entry.value);
        featuresJson[key] = value;
      }
      final featuresString = jsonEncode(featuresJson);
      await _preferences?.setString(_cachedfeaturesKey, featuresString);
      final expiry = DateTime.now().add(cacheDuration);
      await _preferences?.setString(
        _cacheExpirationKey,
        expiry.toIso8601String(),
      );
    } catch (e, stack) {
      logger.severe('Failed to cache features: $e', e, stack);
    }
  }
}
