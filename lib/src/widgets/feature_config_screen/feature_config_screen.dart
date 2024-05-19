import 'package:flutter/material.dart';
import 'package:flutter_feature_manager/flutter_feature_manager.dart';
import 'package:flutter_feature_manager/src/utils.dart/logger.dart';
import 'package:flutter_feature_manager/src/widgets/feature_config_screen/feature_config_screen_body.dart';

bool openFeatureConfigScreen({
  required BuildContext context,
  IFeatureManager? featureManager,
  String title = 'Feature Configuration',
  String description =
      'Configure the features of the app and override their values',
}) {
  try {
    final manager = featureManager ?? context.featureManager;
    if (!manager.config.isOverrideEnabled) return false;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => FeatureConfigScreen(
          manager: manager,
          title: title,
          description: description,
        ),
      ),
    );
    return true;
  } catch (e, stack) {
    logger.severe('Failed to open feature config screen $e', e, stack);
    return false;
  }
}

class FeatureConfigScreen extends StatelessWidget {
  final IFeatureManager manager;
  final String title;
  final String description;

  const FeatureConfigScreen({
    required this.manager,
    required this.title,
    required this.description,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        title: _AppBarTitle(title: title),
        centerTitle: false,
      ),
      body: FeatureManagerProvider(
        manager: manager,
        child: FeatureConfigScreenBody(description: description),
      ),
    );
  }
}

class _AppBarTitle extends StatelessWidget {
  const _AppBarTitle({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(color: Theme.of(context).colorScheme.surface),
    );
  }
}
