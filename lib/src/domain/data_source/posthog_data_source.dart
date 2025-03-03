import 'dart:async';

import 'package:flutter_feature_manager/flutter_feature_manager.dart';
import 'package:flutter_feature_manager/src/utils.dart/logger.dart';
import 'package:posthog_flutter/posthog_flutter.dart';

class PosthogDataSource implements IRemoteDataSource {
  final List<String> keys;
  final FutureOr<void> Function()? initializePosthogIfNeeded;
  final JsonFeatureParser _parser;
  PosthogDataSource({
    required this.keys,
    this.initializePosthogIfNeeded,
    JsonFeatureParser? parser,
  }) : _parser = parser ?? JsonFeatureParser();

  @override
  String get key => 'posthog_data_source';

  @override
  Future<void> initialize() async {
    try {
      await initializePosthogIfNeeded?.call();
      await Posthog().reloadFeatureFlags();
    } catch (e, stack) {
      logger.severe('Failed to initialize Posthog: $e', e, stack);
    }
  }

  @override
  FutureOr<Map<String, Feature<bool>>> loadFeatures() async {
    final features = <String, Feature<bool>>{};
    for (final key in keys) {
      final feature = await _loadFeature(key);
      features[key] = feature;
    }
    return features;
  }

  FutureOr<Feature<bool>> _loadFeature(String key) async {
    try {
      final isEnabled = await Posthog().isFeatureEnabled(key);
      final feature = Feature<bool>(key: key, value: isEnabled);
      final payload = await Posthog().getFeatureFlagPayload(key);
      if (payload == null) return feature;
      final featureWithMetadata = _parser.parse(key, payload);
      return feature.copyWith(
        minVersion: featureWithMetadata.minVersion,
        maxVersion: featureWithMetadata.maxVersion,
        description: featureWithMetadata.description,
        requiresRestart: featureWithMetadata.requiresRestart,
        metadata: featureWithMetadata.metadata,
      );
    } catch (e, stack) {
      logger.severe('Failed to load feature $key from Posthog: $e', e, stack);
      return Feature<bool>(key: key, value: false);
    }
  }
}
