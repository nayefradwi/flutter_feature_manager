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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FeatureBuilder<String>(
              featureKey: titleFeatureKey,
              builder: (context, value) {
                if (value == null) return const SizedBox();
                return Text(value);
              },
            ),
            TextButton(
              onPressed: () {
                openFeatureConfigScreen(context: context);
              },
              child: const Text('Open Feature Config Screen'),
            )
          ],
        ),
      ),
    );
  }
}
