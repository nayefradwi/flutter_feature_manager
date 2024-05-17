import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_feature_manager/src/domain/data_source/data_source.dart';
import 'package:flutter_feature_manager/src/domain/feature.dart';
import 'package:flutter_feature_manager/src/domain/parser/remote_config_feature_parser.dart';
import 'package:flutter_feature_manager/src/utils.dart/logger.dart';

class FirebaseRemoteConfigDataSource implements IFeatureDataSource {
  final FirebaseRemoteConfig remoteConfig;
  final FirebaseRemoteConfigFeatureParser _parser;
  final Duration? timeout;
  final Duration? expiry;

  FirebaseRemoteConfigDataSource({
    required this.remoteConfig,
    String valueKey = 'value',
    this.timeout,
    this.expiry,
  }) : _parser = FirebaseRemoteConfigFeatureParser(valueKey: valueKey);

  @override
  Future<void> initialize() async {
    try {
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: timeout ?? const Duration(seconds: 10),
          minimumFetchInterval: expiry ?? const Duration(hours: 1),
        ),
      );
      await remoteConfig.fetchAndActivate();
    } catch (e, stack) {
      logger.severe(
        'Failed to initialize Firebase Remote Config: $e',
        e,
        stack,
      );
    }
  }

  @override
  Future<Map<String, Feature<String>>> loadFeatures() async {
    try {
      final allValues = remoteConfig.getAll();
      final features = <String, Feature<String>>{};
      for (final entry in allValues.entries) {
        final key = entry.key;
        final value = entry.value;
        final feature = _parser.parse(key, value);
        features[key] = feature;
      }
      return features;
    } catch (e, stack) {
      logger.severe(
        'Failed to load features from Firebase Remote Config: $e',
        e,
        stack,
      );
      return {};
    }
  }

  @override
  String get key => 'firebase_remote_config';
}
