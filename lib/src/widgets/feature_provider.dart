import 'package:flutter/material.dart';
import 'package:flutter_feature_manager/src/domain/manager/abstract_feature_manager.dart';

class FeatureManagerProvider extends InheritedWidget {
  final IFeatureManager manager;
  const FeatureManagerProvider({
    required super.child,
    required this.manager,
    super.key,
  });

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
}
