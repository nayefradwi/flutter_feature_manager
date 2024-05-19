import 'package:flutter/material.dart';
import 'package:flutter_feature_manager/flutter_feature_manager.dart';

class FeatureListItem extends StatelessWidget {
  final Feature<dynamic> feature;
  const FeatureListItem({required this.feature, super.key});

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
          Text(feature.key),
          const SizedBox(height: 8),
          Text(feature.description ?? ''),
          const SizedBox(height: 8),
          Text('Value: ${feature.value}'),
          const SizedBox(height: 8),
          Text('Min version: ${feature.minVersion ?? 'None'}'),
          const SizedBox(height: 8),
          Text('Max version: ${feature.maxVersion ?? 'None'}'),
          const SizedBox(height: 8),
          Text('Requires restart: ${feature.requiresRestart}'),
        ],
      ),
    );
  }
}
