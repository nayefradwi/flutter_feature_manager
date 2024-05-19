import 'package:flutter/material.dart';
import 'package:flutter_feature_manager/flutter_feature_manager.dart';
import 'package:flutter_feature_manager/src/widgets/feature_config_screen/debouncer.dart';

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
        TextField(onChanged: _debounceSearch),
        const SizedBox(height: 16),
        Expanded(child: _FeaturesListView(features)),
      ],
    );
  }

  void _loadFeatures() {
    final features =
        featureManager.features.values.expand((e) => e.values).toList();
    setState(() {
      this.features = features;
    });
  }

  void _debounceSearch(String query) {
    if (query.isEmpty) return _loadFeatures();
    debouncer.run(() {
      final features = featureManager.features.values.expand((e) => e.values);
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
  const _FeaturesListView(this.features);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: features.length,
      itemBuilder: (context, index) {
        final feature = features[index];
        return Text(feature.key);
      },
    );
  }
}
