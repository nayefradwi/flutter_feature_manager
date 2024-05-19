import 'package:flutter/material.dart';
import 'package:flutter_feature_manager/flutter_feature_manager.dart';
import 'package:flutter_feature_manager/src/domain/manager/abstract_feature_manager.dart';

class FeatureManagerProvider extends InheritedWidget {
  final IFeatureManager manager;
  final IFeatureNotifier notifier;
  const FeatureManagerProvider({
    required super.child,
    required this.manager,
    IFeatureNotifier? notifier,
    super.key,
  })  : assert(
          notifier != null || manager is IFeatureNotifier,
          'IFeatureNotifier is required if'
          ' IFeatureManager does not implement it',
        ),
        notifier = notifier ?? manager as IFeatureNotifier;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }

  static FeatureManagerProvider of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<FeatureManagerProvider>();
    if (provider == null) throw Exception('FeatureManagerProvider not found');
    return provider;
  }

  bool get isOverrideEnabled => manager.config.isOverrideEnabled;
}
