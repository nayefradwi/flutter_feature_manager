import 'package:custom_backend_example/feature_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feature_manager/flutter_feature_manager.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Center(child: _Body()),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _TitleFeature(),
        _OpenConfigBtn(),
        _RequiresRestartFeature(),
      ],
    );
  }
}

class _TitleFeature extends StatelessWidget {
  const _TitleFeature();

  @override
  Widget build(BuildContext context) {
    return FeatureBuilder<String>(
      featureKey: titleFeatureKey,
      builder: (context, value) {
        if (value == null) return const SizedBox();
        return Text(value);
      },
    );
  }
}

class _OpenConfigBtn extends StatelessWidget {
  const _OpenConfigBtn();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        openFeatureConfigScreen(context: context);
      },
      child: const Text('Open Feature Config Screen'),
    );
  }
}

class _RequiresRestartFeature extends StatelessWidget {
  const _RequiresRestartFeature();

  @override
  Widget build(BuildContext context) {
    final feature = context.featureManager.getFeature<String>(
      descriptionFeatureKey,
      defaultValue: '',
    );
    return Text(feature.value);
  }
}
