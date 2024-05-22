import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_remote_config_example/app.dart';
import 'package:firebase_remote_config_example/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feature_manager/flutter_feature_manager.dart';

const titleFeatureKey = 'title';
const isDarkModeKey = 'is_dark_mode';
const descriptionFeatureKey = 'description';
const defaultFeatureKey = 'default';

IFeatureManager createFeatureManager() {
  return FeatureManager(
    remoteDataSource: FirebaseRemoteConfigDataSource(
      remoteConfig: FirebaseRemoteConfig.instance,
    ),
    restartApp: () {
      final context = navigatorKey.currentContext;
      if (context == null) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const SplashScreen()),
        (route) => false,
      );
    },
    defaultsDataSource: DefaultsDataSource(defaultFeatures: {}),
  );
}
