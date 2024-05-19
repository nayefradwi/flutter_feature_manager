import 'package:flutter/material.dart';
import 'package:flutter_feature_manager/src/widgets/feature_config_screen/features_list_view.dart';

class FeatureConfigScreenBody extends StatelessWidget {
  final String description;
  const FeatureConfigScreenBody({required this.description, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DescriptionText(description),
        const SizedBox(height: 8),
        const Expanded(child: FeatureListView()),
      ],
    );
  }
}

class _DescriptionText extends StatelessWidget {
  const _DescriptionText(this.description);

  final String description;

  @override
  Widget build(BuildContext context) {
    return Text(
      description,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
