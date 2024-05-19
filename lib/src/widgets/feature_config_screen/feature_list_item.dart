import 'package:flutter/material.dart';
import 'package:flutter_feature_manager/flutter_feature_manager.dart';
import 'package:flutter_feature_manager/src/widgets/feature_config_screen/feature_list_item_field.dart';

class FeatureListItem extends StatelessWidget {
  final Feature<dynamic> feature;
  final void Function(Feature<dynamic> feature) onChanged;
  const FeatureListItem({
    required this.feature,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FeatureKeyTitle(featureKey: feature.key),
          if (feature.description != null)
            _DescriptionText(description: feature.description!),
          _FeatureListItemField(feature: feature, onChanged: onChanged),
          const SizedBox(height: 8),
          Text('Min version: ${feature.minVersion ?? 'None'}'),
          const SizedBox(height: 8),
          Text('Max version: ${feature.maxVersion ?? 'None'}'),
          const SizedBox(height: 8),
          if (feature.requiresRestart) const _RequiresRestartText(),
        ],
      ),
    );
  }
}

class _FeatureListItemField extends StatefulWidget {
  const _FeatureListItemField({
    required this.feature,
    required this.onChanged,
  });

  final Feature<dynamic> feature;
  final void Function(Feature<dynamic> feature) onChanged;

  @override
  State<_FeatureListItemField> createState() => _FeatureListItemFieldState();
}

class _FeatureListItemFieldState extends State<_FeatureListItemField> {
  late Feature<dynamic> feature;

  @override
  void initState() {
    feature = widget.feature;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FeatureListItemField(
      value: feature.value,
      onChanged: (newValue) {
        if (!context.isFeatureOverrideEnabled) return;
        final newFeature = feature.withValue(newValue);
        widget.onChanged(newFeature);
        setState(() {
          feature = newFeature;
        });
      },
    );
  }
}

class _RequiresRestartText extends StatelessWidget {
  const _RequiresRestartText();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Requires restart',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.error,
      ),
    );
  }
}

class _FeatureKeyTitle extends StatelessWidget {
  const _FeatureKeyTitle({required this.featureKey});

  final String featureKey;

  @override
  Widget build(BuildContext context) {
    return Text(
      featureKey,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _DescriptionText extends StatelessWidget {
  const _DescriptionText({required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        description,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
      ),
    );
  }
}
