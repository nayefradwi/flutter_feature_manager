// This class should rebuild the widget
// based on if a feature is enabled or not.
import 'package:flutter/widgets.dart';
import 'package:flutter_feature_manager/src/extensions/context.dart';

class FeatureBuilder<T> extends StatelessWidget {
  final String featureKey;
  final Widget Function(BuildContext context, T? value) builder;
  const FeatureBuilder({
    required this.featureKey,
    required this.builder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final manager = context.featureManager;
    final feature = manager.tryToGetFeature<T>(featureKey);
    return builder(context, feature?.value);
  }
}

class FeatureBuilderWithDefault<T> extends StatelessWidget {
  final String featureKey;
  final T defaultValue;
  final Widget Function(BuildContext context, T value) builder;
  const FeatureBuilderWithDefault({
    required this.featureKey,
    required this.defaultValue,
    required this.builder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final manager = context.featureManager;
    final feature = manager.tryToGetFeature<T>(featureKey);
    final value = feature?.value ?? defaultValue;
    return builder(context, value);
  }
}

class FeatureFlagBuilder extends FeatureBuilderWithDefault<bool> {
  const FeatureFlagBuilder({
    required super.featureKey,
    required super.builder,
    super.key,
  }) : super(defaultValue: false);
}
