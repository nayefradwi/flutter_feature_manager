import 'package:flutter/material.dart';
import 'package:flutter_feature_manager/flutter_feature_manager.dart';
import 'package:flutter_feature_manager/src/widgets/feature_config_screen/debouncer.dart';
import 'package:flutter_feature_manager/src/widgets/feature_config_screen/feature_list_item.dart';

class FeatureListView extends StatefulWidget {
  const FeatureListView({super.key});

  @override
  State<FeatureListView> createState() => _FeatureListViewState();
}

class _FeatureListViewState extends State<FeatureListView> {
  final listController = ScrollController();
  final debouncer = Debouncer(delay: const Duration(milliseconds: 500));
  IFeatureManager get featureManager => context.featureManager;
  List<Feature<dynamic>> features = [];
  Map<String, Feature<dynamic>> featuresChanged = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFeatures();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          onChanged: _debounceSearch,
          decoration: const InputDecoration(
            labelText: 'Search features',
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: _FeaturesListView(
            features: features,
            onChanged: _updateChangedFeatures,
          ),
        ),
        if (featuresChanged.isNotEmpty)
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: _saveOverrides,
              child: const Text('Save changes'),
            ),
          ),
      ],
    );
  }

  void _updateChangedFeatures(Feature<dynamic> feature) {
    setState(() {
      featuresChanged[feature.key] = feature;
    });
  }

  void _saveOverrides() {
    if (featureManager is! IOverridableFeatureManager) return;
    (featureManager as IOverridableFeatureManager)
        .overrideFeatures(featuresChanged);
    setState(() {
      featuresChanged.clear();
    });
  }

  void _loadFeatures() {
    debouncer.cancel();
    final features = featureManager.getFeatures();
    setState(() {
      this.features = features;
    });
  }

  void _debounceSearch(String query) {
    if (query.isEmpty) return _loadFeatures();
    debouncer.run(() {
      final features = [...featureManager.getFeatures()];
      final filtered = features.where((e) => e.key.contains(query)).toList();
      setState(() {
        this.features = filtered;
      });
    });
  }

  @override
  void dispose() {
    listController.dispose();
    debouncer.dispose();
    super.dispose();
  }
}

class _FeaturesListView extends StatelessWidget {
  final List<Feature<dynamic>> features;
  final void Function(Feature<dynamic> feature) onChanged;
  const _FeaturesListView({
    required this.onChanged,
    required this.features,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: features.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final feature = features[index];
        return FeatureListItem(feature: feature, onChanged: onChanged);
      },
    );
  }
}
