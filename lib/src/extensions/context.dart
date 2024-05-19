import 'package:flutter/widgets.dart';
import 'package:flutter_feature_manager/src/domain/manager/abstract_feature_manager.dart';
import 'package:flutter_feature_manager/src/widgets/feature_provider.dart';

extension FeatureContextExtension on BuildContext {
  IFeatureManager get featureManager => FeatureManagerProvider.of(this).manager;
  IFeatureNotifier? get featureNotifier =>
      FeatureManagerProvider.of(this).notifier;

  bool get isFeatureOverrideEnabled => featureManager.config.isOverrideEnabled;
}
