import 'package:flutter/widgets.dart';
import 'package:flutter_feature_manager/src/domain/feature.dart';
import 'package:flutter_feature_manager/src/extensions/context.dart';

class FeatureBuilder<T> extends StatefulWidget {
  final String featureKey;
  final Widget Function(BuildContext context, T? value) builder;
  const FeatureBuilder({
    required this.featureKey,
    required this.builder,
    super.key,
  });

  @override
  State<FeatureBuilder<T>> createState() => _FeatureBuilderState<T>();
}

class _FeatureBuilderState<T> extends State<FeatureBuilder<T>> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.featureManager.addFeatureListener<T>(
        key: widget.featureKey,
        listener: _onFeatureChange,
      );
    });
  }

  void _onFeatureChange({
    required Feature<T>? previous,
    required Feature<T> current,
  }) {
    if (previous?.value != current.value) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final manager = context.featureManager;
    final feature = manager.tryToGetFeature<T>(widget.featureKey);
    return widget.builder(context, feature?.value);
  }

  @override
  void dispose() {
    super.dispose();
    context.featureManager.removeFeatureListener<T>(
      key: widget.featureKey,
      listener: _onFeatureChange,
    );
  }
}

class FeatureBuilderWithDefault<T> extends StatefulWidget {
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
  State<FeatureBuilderWithDefault<T>> createState() =>
      _FeatureBuilderWithDefaultState<T>();
}

class _FeatureBuilderWithDefaultState<T>
    extends State<FeatureBuilderWithDefault<T>> {
  String get featureKey => widget.featureKey;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.featureManager.addFeatureListener<T>(
        key: featureKey,
        listener: _onFeatureChange,
      );
    });
  }

  void _onFeatureChange({
    required Feature<T>? previous,
    required Feature<T> current,
  }) {
    if (previous?.value != current.value) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final manager = context.featureManager;
    final feature = manager.tryToGetFeature<T>(widget.featureKey);
    final value = feature?.value ?? widget.defaultValue;
    return widget.builder(context, value);
  }

  @override
  void dispose() {
    super.dispose();
    context.featureManager.removeFeatureListener<T>(
      key: featureKey,
      listener: _onFeatureChange,
    );
  }
}

class FeatureFlagBuilder extends FeatureBuilderWithDefault<bool> {
  const FeatureFlagBuilder({
    required super.featureKey,
    required super.builder,
    super.key,
  }) : super(defaultValue: false);
}
