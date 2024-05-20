import 'dart:async';

import 'package:custom_backend_example/app.dart';
import 'package:custom_backend_example/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feature_manager/flutter_feature_manager.dart';

const titleFeatureKey = 'title';
const isDarkModeKey = 'is_dark_mode';
const descriptionFeatureKey = 'description';
const defaultFeatureKey = 'default';

class RemoteDataSource with IRemoteDataSource {
  @override
  Future<void> initialize() async {}

  @override
  String get key => 'custom_remote';

  @override
  FutureOr<Map<String, Feature<String>>> loadFeatures() {
    return {
      titleFeatureKey: Feature(
        key: titleFeatureKey,
        value: 'Custom Remote Title',
        minVersion: '0.0.0',
        maxVersion: '100.0.0',
        description: 'Custom Remote Title Description',
      ),
      isDarkModeKey: Feature(
        key: isDarkModeKey,
        value: false.toString(),
      ),
      descriptionFeatureKey: Feature(
        key: descriptionFeatureKey,
        value: 'Custom Remote Description',
        requiresRestart: true,
      ),
    };
  }
}

IFeatureManager createFeatureManager() {
  return FeatureManager(
    remoteDataSource: RemoteDataSource(),
    restartApp: () {
      final context = navigatorKey.currentContext;
      if (context == null) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const SplashScreen()),
        (route) => false,
      );
    },
    defaultsDataSource: DefaultsDataSource(
      defaultFeatures: {
        defaultFeatureKey: Feature(
          key: defaultFeatureKey,
          value: 100.toString(),
        )
      },
    ),
  );
}
